import 'dart:math';

class NoteResult {
  final String noteName;
  final int octave;

  /// Deviation from the nearest semitone, range –50..+50 cents.
  final double cents;

  final double frequency;

  const NoteResult({
    required this.noteName,
    required this.octave,
    required this.cents,
    required this.frequency,
  });
}

abstract final class MusicUtils {
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  /// Converts a frequency (Hz) to a [NoteResult].
  ///
  /// Returns null if the frequency is outside the musical range C1–C8.
  static NoteResult? frequencyToNote(
    double frequency, {
    double referenceA4 = 440.0,
  }) {
    if (frequency <= 0 || frequency.isNaN || frequency.isInfinite) return null;

    // MIDI note number (A4 = 69)
    final noteNumber = 12 * log(frequency / referenceA4) / ln2 + 69;
    final nearestMidi = noteNumber.round();

    // Valid range: C1 (MIDI 24) to C8 (MIDI 108)
    if (nearestMidi < 24 || nearestMidi > 108) return null;

    final cents = (noteNumber - nearestMidi) * 100;
    final noteIndex = ((nearestMidi % 12) + 12) % 12;
    final octave = (nearestMidi ~/ 12) - 1;

    return NoteResult(
      noteName: noteNames[noteIndex],
      octave: octave,
      cents: cents.clamp(-50.0, 50.0),
      frequency: frequency,
    );
  }

  /// Returns the Italian tempo name for a given BPM value.
  static String tempoName(int bpm) {
    if (bpm < 60) return 'Largo';
    if (bpm < 66) return 'Larghetto';
    if (bpm < 76) return 'Adagio';
    if (bpm < 108) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 156) return 'Allegro';
    if (bpm < 176) return 'Vivace';
    return 'Presto';
  }
}
