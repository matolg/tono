import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

// ── Top-level function required by compute() ─────────────────────────────────

double? _runYin(List<Object> args) {
  final buffer = args[0] as Float64List;
  final sampleRate = args[1] as int;
  return _yin(buffer, sampleRate);
}

/// YIN pitch detection algorithm.
/// Returns the fundamental frequency in Hz, or null if none found.
double? _yin(Float64List buffer, int sampleRate, {double threshold = 0.15}) {
  final n = buffer.length;
  final half = n ~/ 2;
  final d = Float64List(half);

  // Step 2: Difference function
  for (int tau = 1; tau < half; tau++) {
    double sum = 0;
    for (int j = 0; j < half; j++) {
      final delta = buffer[j] - buffer[j + tau];
      sum += delta * delta;
    }
    d[tau] = sum;
  }

  // Step 3: Cumulative mean normalized difference function
  d[0] = 1;
  double running = 0;
  for (int tau = 1; tau < half; tau++) {
    running += d[tau];
    d[tau] = d[tau] * tau / running;
  }

  // Step 4: Absolute threshold — find first tau below threshold (local min)
  int tau = 2;
  while (tau < half - 1) {
    if (d[tau] < threshold) {
      while (tau + 1 < half - 1 && d[tau + 1] < d[tau]) { tau++; }
      break;
    }
    tau++;
  }

  if (tau >= half - 1 || d[tau] >= threshold) return null;

  // Step 5: Parabolic interpolation for sub-sample accuracy
  final betterTau = _parabolicInterp(d, tau);
  if (betterTau <= 0) return null;

  return sampleRate / betterTau;
}

double _parabolicInterp(Float64List d, int tau) {
  if (tau <= 0 || tau >= d.length - 1) return tau.toDouble();
  final y0 = d[tau - 1], y1 = d[tau], y2 = d[tau + 1];
  final denom = y0 + y2 - 2 * y1;
  if (denom.abs() < 1e-10) return tau.toDouble();
  return tau + (y0 - y2) / (2 * denom);
}

// ── PitchDetector ─────────────────────────────────────────────────────────────

class PitchDetector {
  static const int _sampleRate = 44100;
  static const int _bufferSize = 4096;

  final AudioRecorder _recorder = AudioRecorder();
  final StreamController<double?> _controller =
      StreamController<double?>.broadcast();
  final List<int> _samples = [];
  StreamSubscription<Uint8List>? _sub;

  Stream<double?> get frequencies => _controller.stream;

  Future<void> start() async {
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _sampleRate,
        numChannels: 1,
      ),
    );
    _sub = stream.listen(_onChunk);
  }

  void _onChunk(Uint8List chunk) {
    // Parse signed 16-bit little-endian PCM samples
    for (int i = 0; i + 1 < chunk.length; i += 2) {
      int s = chunk[i] | (chunk[i + 1] << 8);
      if (s >= 32768) s -= 65536;
      _samples.add(s);
    }

    while (_samples.length >= _bufferSize) {
      final frame = Float64List(_bufferSize);
      for (int i = 0; i < _bufferSize; i++) {
        frame[i] = _samples[i] / 32768.0;
      }
      _samples.removeRange(0, _bufferSize);
      _processFrame(frame);
    }
  }

  void _processFrame(Float64List frame) async {
    // Skip near-silent frames to avoid noise false-positives
    double energy = 0;
    for (final s in frame) { energy += s * s; }
    if (energy / _bufferSize < 0.0001) {
      if (!_controller.isClosed) _controller.add(null);
      return;
    }

    final freq = await compute(_runYin, <Object>[frame, _sampleRate]);
    if (!_controller.isClosed) _controller.add(freq);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    if (await _recorder.isRecording()) await _recorder.stop();
    _samples.clear();
  }

  Future<void> dispose() async {
    await stop();
    if (!_controller.isClosed) await _controller.close();
    _recorder.dispose();
  }
}
