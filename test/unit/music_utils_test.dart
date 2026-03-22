import 'package:flutter_test/flutter_test.dart';
import 'package:tono/core/utils/music_utils.dart';

void main() {
  // ── frequencyToNote ──────────────────────────────────────────────────────────

  group('MusicUtils.frequencyToNote', () {
    test('A4 = 440 Hz → note A, octave 4, ~0 cents', () {
      final r = MusicUtils.frequencyToNote(440.0);
      expect(r, isNotNull);
      expect(r!.noteName, 'A');
      expect(r.octave, 4);
      expect(r.cents.abs(), lessThan(0.5));
      expect(r.frequency, 440.0);
    });

    test('C4 ≈ 261.63 Hz', () {
      final r = MusicUtils.frequencyToNote(261.63);
      expect(r, isNotNull);
      expect(r!.noteName, 'C');
      expect(r.octave, 4);
    });

    test('C#4 / Db4 ≈ 277.18 Hz', () {
      final r = MusicUtils.frequencyToNote(277.18);
      expect(r, isNotNull);
      expect(r!.noteName, 'C#');
      expect(r.octave, 4);
    });

    test('B3 ≈ 246.94 Hz', () {
      final r = MusicUtils.frequencyToNote(246.94);
      expect(r, isNotNull);
      expect(r!.noteName, 'B');
      expect(r.octave, 3);
    });

    test('A4 with custom reference 432 → sharper', () {
      // At reference 432, A4=440 should appear sharp (positive cents)
      final r = MusicUtils.frequencyToNote(440.0, referenceA4: 432.0);
      expect(r, isNotNull);
      expect(r!.cents, greaterThan(0));
    });

    test('zero frequency returns null', () {
      expect(MusicUtils.frequencyToNote(0.0), isNull);
    });

    test('negative frequency returns null', () {
      expect(MusicUtils.frequencyToNote(-100.0), isNull);
    });

    test('NaN returns null', () {
      expect(MusicUtils.frequencyToNote(double.nan), isNull);
    });

    test('infinity returns null', () {
      expect(MusicUtils.frequencyToNote(double.infinity), isNull);
    });

    test('below C1 (~32.7 Hz) returns null', () {
      expect(MusicUtils.frequencyToNote(20.0), isNull);
    });

    test('above C8 (~4186 Hz) returns null', () {
      expect(MusicUtils.frequencyToNote(5000.0), isNull);
    });

    test('cents stay within –50..+50 range', () {
      for (final freq in [200.0, 300.0, 440.0, 880.0, 1760.0]) {
        final r = MusicUtils.frequencyToNote(freq);
        if (r != null) {
          expect(r.cents, greaterThanOrEqualTo(-50.0));
          expect(r.cents, lessThanOrEqualTo(50.0));
        }
      }
    });
  });

  // ── tempoName ────────────────────────────────────────────────────────────────

  group('MusicUtils.tempoName', () {
    test('Largo: bpm < 60', () {
      expect(MusicUtils.tempoName(40), 'Largo');
      expect(MusicUtils.tempoName(59), 'Largo');
    });

    test('Larghetto: 60–65', () {
      expect(MusicUtils.tempoName(60), 'Larghetto');
      expect(MusicUtils.tempoName(65), 'Larghetto');
    });

    test('Adagio: 66–75', () {
      expect(MusicUtils.tempoName(66), 'Adagio');
      expect(MusicUtils.tempoName(75), 'Adagio');
    });

    test('Andante: 76–107', () {
      expect(MusicUtils.tempoName(76), 'Andante');
      expect(MusicUtils.tempoName(107), 'Andante');
    });

    test('Moderato: 108–119', () {
      expect(MusicUtils.tempoName(108), 'Moderato');
      expect(MusicUtils.tempoName(119), 'Moderato');
    });

    test('Allegro: 120–155', () {
      expect(MusicUtils.tempoName(120), 'Allegro');
      expect(MusicUtils.tempoName(155), 'Allegro');
    });

    test('Vivace: 156–175', () {
      expect(MusicUtils.tempoName(156), 'Vivace');
      expect(MusicUtils.tempoName(175), 'Vivace');
    });

    test('Presto: 176+', () {
      expect(MusicUtils.tempoName(176), 'Presto');
      expect(MusicUtils.tempoName(220), 'Presto');
    });
  });
}
