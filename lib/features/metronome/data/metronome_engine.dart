import 'dart:async';
import 'dart:isolate';

import 'package:flutter_soloud/flutter_soloud.dart';

// ── Isolate entry point ───────────────────────────────────────────────────────

void _timerIsolate(SendPort mainPort) {
  final port = ReceivePort();
  mainPort.send(port.sendPort); // hand back control port

  Timer? timer;

  port.listen((msg) {
    if (msg is int) {
      // New BPM received — (re)start timer
      timer?.cancel();
      final interval = Duration(microseconds: (60000000 / msg).round());
      mainPort.send('beat'); // first beat immediately
      timer = Timer.periodic(interval, (_) => mainPort.send('beat'));
    } else if (msg == 'stop') {
      timer?.cancel();
      timer = null;
    } else if (msg == 'quit') {
      timer?.cancel();
      port.close();
    }
  });
}

// ── MetronomeEngine ───────────────────────────────────────────────────────────

class MetronomeEngine {
  final _soloud = SoLoud.instance;
  AudioSource? _accent;
  AudioSource? _tick;

  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _isolateSendPort;

  bool _running = false;
  int _beat = 0;
  int _beatsPerBar = 4;

  /// Called on every beat with the beat index (0 = accent).
  void Function(int beat)? onBeat;

  Future<void> init() async {
    if (!_soloud.isInitialized) await _soloud.init(bufferSize: 4096);
    _accent = await _soloud.loadAsset('assets/sounds/metronome_accent.wav');
    _tick = await _soloud.loadAsset('assets/sounds/metronome_tick.wav');
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
        _isolateSendPort!.send(bpm); // kick off the timer
      } else if (msg == 'beat') {
        _fireBeat();
      }
    });
  }

  /// Change BPM on the fly — sends new BPM to the isolate timer.
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
    if (_accent != null) await _soloud.disposeSource(_accent!);
    if (_tick != null) await _soloud.disposeSource(_tick!);
  }

  void _fireBeat() {
    if (!_running) return;
    final source = _beat == 0 ? _accent : _tick;
    if (source != null) _soloud.play(source);
    onBeat?.call(_beat);
    _beat = (_beat + 1) % _beatsPerBar;
  }
}
