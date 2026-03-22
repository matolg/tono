import 'dart:async';
import 'dart:isolate';

import 'package:flutter_soloud/flutter_soloud.dart';

// ── Isolate entry point ───────────────────────────────────────────────────────
//
// Uses a generation counter to cleanly cancel loops when BPM changes or stop
// is requested — no Timer.periodic, no accumulated drift.

void _timerIsolate(SendPort mainPort) {
  final port = ReceivePort();
  mainPort.send(port.sendPort);

  int generation = 0;

  Future<void> runLoop(int bpm, int gen) async {
    final interval = Duration(microseconds: (60000000 / bpm).round());
    var nextBeat = DateTime.now();

    while (generation == gen) {
      mainPort.send('beat');
      // Advance target time by one exact interval (drift-corrected).
      nextBeat = nextBeat.add(interval);
      final delay = nextBeat.difference(DateTime.now());
      if (delay.inMicroseconds > 500) {
        await Future.delayed(delay);
      }
      // If we fell behind, loop immediately without sleeping (catch-up).
    }
  }

  port.listen((msg) {
    if (msg is int) {
      generation++;             // cancels any running loop
      runLoop(msg, generation); // start new loop (fire-and-forget)
    } else if (msg == 'quit') {
      generation++;             // stop loop
      port.close();
    }
  });
}

// ── MetronomeEngine ───────────────────────────────────────────────────────────

class MetronomeEngine {
  final _soloud = SoLoud.instance;
  AudioSource? _accent;
  AudioSource? _tick;

  bool _initialized = false;

  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _isolateSendPort;

  bool _running = false;
  int _beat = 0;
  int _beatsPerBar = 4;

  /// Called on every beat with the beat index (0 = accent).
  void Function(int beat)? onBeat;

  /// Safe to call multiple times — loads sounds only once.
  Future<void> init() async {
    if (_initialized) return;
    if (!_soloud.isInitialized) await _soloud.init(bufferSize: 2048);
    _accent = await _soloud.loadAsset('assets/sounds/metronome_accent.wav');
    _tick = await _soloud.loadAsset('assets/sounds/metronome_tick.wav');
    _initialized = true;
  }

  Future<void> start(int bpm, int beatsPerBar) async {
    _running = true;
    _beatsPerBar = beatsPerBar;
    _beat = 0;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_timerIsolate, _receivePort!.sendPort);

    _receivePort!.listen((msg) {
      if (msg is SendPort) {
        _isolateSendPort = msg;
        _isolateSendPort!.send(bpm);
      } else if (msg == 'beat') {
        _fireBeat();
      }
    });
  }

  /// Change BPM on the fly — restarts the loop in the isolate.
  void updateBpm(int bpm) {
    _isolateSendPort?.send(bpm);
  }

  void updateBeatsPerBar(int beatsPerBar) {
    _beatsPerBar = beatsPerBar;
    _beat = _beat % beatsPerBar;
  }

  void stop() {
    _running = false;
    _isolateSendPort?.send('quit');
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
    _isolateSendPort = null;
    _beat = 0;
  }

  Future<void> dispose() async {
    stop();
    if (_accent != null) {
      await _soloud.disposeSource(_accent!);
      _accent = null;
    }
    if (_tick != null) {
      await _soloud.disposeSource(_tick!);
      _tick = null;
    }
    _initialized = false;
  }

  void _fireBeat() {
    if (!_running) return;
    final source = _beat == 0 ? _accent : _tick;
    if (source != null) {
      try {
        _soloud.play(source);
      } catch (_) {
        // SoLoud may reject play() during shutdown — ignore silently.
      }
    }
    onBeat?.call(_beat);
    _beat = (_beat + 1) % _beatsPerBar;
  }
}
