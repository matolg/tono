enum TunerStatus { idle, listening, detected, error }

class TunerState {
  final TunerStatus status;
  final String? noteName;
  final int? octave;
  final double? frequency;

  /// Deviation from nearest semitone, –50..+50 cents.
  final double? cents;

  /// Reference pitch for A4 in Hz (default 440).
  final double referenceA4;

  const TunerState({
    this.status = TunerStatus.idle,
    this.noteName,
    this.octave,
    this.frequency,
    this.cents,
    this.referenceA4 = 440.0,
  });

  TunerState copyWith({
    TunerStatus? status,
    String? noteName,
    int? octave,
    double? frequency,
    double? cents,
    double? referenceA4,
    bool clearNote = false,
  }) {
    return TunerState(
      status: status ?? this.status,
      noteName: clearNote ? null : (noteName ?? this.noteName),
      octave: clearNote ? null : (octave ?? this.octave),
      frequency: clearNote ? null : (frequency ?? this.frequency),
      cents: clearNote ? null : (cents ?? this.cents),
      referenceA4: referenceA4 ?? this.referenceA4,
    );
  }
}
