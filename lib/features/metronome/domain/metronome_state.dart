enum MetronomeStatus { stopped, playing }

class MetronomeState {
  final MetronomeStatus status;
  final int bpm;
  final int beatsPerBar;
  final int beatUnit;
  final int currentBeat; // 0-indexed; 0 = accent

  const MetronomeState({
    this.status = MetronomeStatus.stopped,
    this.bpm = 120,
    this.beatsPerBar = 4,
    this.beatUnit = 4,
    this.currentBeat = 0,
  });

  bool get isPlaying => status == MetronomeStatus.playing;

  MetronomeState copyWith({
    MetronomeStatus? status,
    int? bpm,
    int? beatsPerBar,
    int? beatUnit,
    int? currentBeat,
  }) =>
      MetronomeState(
        status: status ?? this.status,
        bpm: bpm ?? this.bpm,
        beatsPerBar: beatsPerBar ?? this.beatsPerBar,
        beatUnit: beatUnit ?? this.beatUnit,
        currentBeat: currentBeat ?? this.currentBeat,
      );

  static const int minBpm = 40;
  static const int maxBpm = 220;
}
