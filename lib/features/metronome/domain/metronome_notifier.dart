import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/metronome_engine.dart';
import 'metronome_state.dart';

const _keyBpm = 'metronome_bpm';
const _keyBeatsPerBar = 'metronome_beats_per_bar';
const _keyBeatUnit = 'metronome_beat_unit';

class MetronomeNotifier extends Notifier<MetronomeState> {
  final _engine = MetronomeEngine();

  @override
  MetronomeState build() {
    ref.onDispose(_onDispose);
    _loadPrefs();
    _engine.onBeat = (beat) {
      state = state.copyWith(currentBeat: beat);
    };
    return const MetronomeState();
  }

  Future<void> init() async {
    await _engine.init();
  }

  void start() {
    _engine.start(state.bpm, state.beatsPerBar);
    state = state.copyWith(status: MetronomeStatus.playing, currentBeat: 0);
  }

  void stop() {
    _engine.stop();
    state = state.copyWith(status: MetronomeStatus.stopped, currentBeat: 0);
  }

  void setBpm(int bpm) {
    final clamped = bpm.clamp(MetronomeState.minBpm, MetronomeState.maxBpm);
    state = state.copyWith(bpm: clamped);
    if (state.isPlaying) _engine.updateBpm(clamped);
    _savePrefs();
  }

  void setBeatsPerBar(int beats) {
    state = state.copyWith(beatsPerBar: beats);
    if (state.isPlaying) _engine.updateBeatsPerBar(beats);
    _savePrefs();
  }

  void setBeatUnit(int unit) {
    state = state.copyWith(beatUnit: unit);
    _savePrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      bpm: prefs.getInt(_keyBpm) ?? 120,
      beatsPerBar: prefs.getInt(_keyBeatsPerBar) ?? 4,
      beatUnit: prefs.getInt(_keyBeatUnit) ?? 4,
    );
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBpm, state.bpm);
    await prefs.setInt(_keyBeatsPerBar, state.beatsPerBar);
    await prefs.setInt(_keyBeatUnit, state.beatUnit);
  }

  Future<void> _onDispose() async {
    await _engine.dispose();
  }
}

final metronomeProvider =
    NotifierProvider<MetronomeNotifier, MetronomeState>(MetronomeNotifier.new);
