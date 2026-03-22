import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:pitch_detector_dart/pitch_detector.dart' as pd;

class PitchDetector {
  static const int _sampleRate = 44100;
  // 2048 samples × 2 bytes (PCM16) = 4096 bytes per frame
  static const int _bufferSamples = 4096;
  static const int _bufferBytes = _bufferSamples * 2;

  final _detector = pd.PitchDetector(
    audioSampleRate: _sampleRate.toDouble(),
    bufferSize: _bufferSamples,
  );

  AudioRecorder _recorder = AudioRecorder();
  final StreamController<double?> _controller =
      StreamController<double?>.broadcast();
  final List<int> _bytes = [];
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

    _sub = stream.listen(
      _onChunk,
      onDone: _onStreamDone,
      onError: (_) => _onStreamDone(),
      cancelOnError: false,
    );
  }

  void _onChunk(Uint8List chunk) {
    _bytes.addAll(chunk);

    // Prevent unbounded growth if processing falls behind
    if (_bytes.length > _bufferBytes * 4) {
      _bytes.removeRange(0, _bytes.length - _bufferBytes);
    }

    while (_bytes.length >= _bufferBytes) {
      final frame = Uint8List.fromList(_bytes.sublist(0, _bufferBytes));
      _bytes.removeRange(0, _bufferBytes);
      _processFrame(frame);
    }
  }

  void _processFrame(Uint8List frame) {
    // Skip near-silent frames (check energy via Int16 view)
    final samples = frame.buffer.asInt16List();
    double energy = 0;
    for (final s in samples) {
      final f = s / 32768.0;
      energy += f * f;
    }
    if (energy / samples.length < 0.0001) {
      if (!_controller.isClosed) _controller.add(null);
      return;
    }

    _detector.getPitchFromIntBuffer(frame).then((result) {
      if (!_controller.isClosed) {
        _controller.add(result.pitched ? result.pitch : null);
      }
    });
  }

  void _onStreamDone() async {
    if (_controller.isClosed) return;
    _bytes.clear();
    await _sub?.cancel();
    _sub = null;
    try { await _recorder.stop(); } catch (_) {}
    try { _recorder.dispose(); } catch (_) {}
    _recorder = AudioRecorder();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_controller.isClosed) {
      try { await start(); } catch (_) {}
    }
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _bytes.clear();
    try {
      if (await _recorder.isRecording()) await _recorder.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    if (!_controller.isClosed) await _controller.close();
    _recorder.dispose();
  }
}
