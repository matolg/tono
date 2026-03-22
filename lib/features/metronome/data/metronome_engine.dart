import 'dart:async';

import 'package:flutter_soloud/flutter_soloud.dart';

class MetronomeEngine {
  final _soloud = SoLoud.instance;
  AudioSource? _accent;
  AudioSource? _tick;
  Timer? _timer;
  int _beat = 0;
  int _beatsPerBar = 4;

  /// Called on every beat with the beat index (0 = accent).
  void Function(int beat)? onBeat;

  Future<void> init() async {
    if (!_soloud.isInitialized) await _soloud.init();
    _accent = await _soloud.loadAsset('assets/sounds/metronome_accent.wav');
    _tick = await _soloud.loadAsset('assets/sounds/metronome_tick.wav');
  }

  void start(int bpm, int beatsPerBar) {
    _beatsPerBar = beatsPerBar;
    _beat = 0;
    _fire();
    _timer = Timer.periodic(_interval(bpm), (_) => _fire());
  }

  /// Change BPM on the fly without resetting the beat counter.
  void updateBpm(int bpm) {
    if (_timer == null) return;
    _timer!.cancel();
    _timer = Timer.periodic(_interval(bpm), (_) => _fire());
  }

  void updateBeatsPerBar(int beatsPerBar) {
    _beatsPerBar = beatsPerBar;
    _beat = _beat % beatsPerBar;
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _beat = 0;
  }

  Future<void> dispose() async {
    stop();
    if (_accent != null) await _soloud.disposeSource(_accent!);
    if (_tick != null) await _soloud.disposeSource(_tick!);
  }

  Duration _interval(int bpm) =>
      Duration(microseconds: (60000000 / bpm).round());

  void _fire() {
    final isAccent = _beat == 0;
    final source = isAccent ? _accent : _tick;
    if (source != null) _soloud.play(source);
    onBeat?.call(_beat);
    _beat = (_beat + 1) % _beatsPerBar;
  }
}
