import 'package:flutter_test/flutter_test.dart';
import 'package:tono/features/tuner/domain/tuner_state.dart';

void main() {
  group('TunerState', () {
    test('default values', () {
      const s = TunerState();
      expect(s.status, TunerStatus.idle);
      expect(s.noteName, isNull);
      expect(s.octave, isNull);
      expect(s.frequency, isNull);
      expect(s.cents, isNull);
      expect(s.referenceA4, 440.0);
    });

    test('copyWith updates status', () {
      const s = TunerState();
      expect(
        s.copyWith(status: TunerStatus.listening).status,
        TunerStatus.listening,
      );
    });

    test('copyWith clearNote wipes all note fields', () {
      const s = TunerState(
        status: TunerStatus.detected,
        noteName: 'A',
        octave: 4,
        frequency: 440.0,
        cents: 0.0,
      );
      final s2 = s.copyWith(status: TunerStatus.listening, clearNote: true);
      expect(s2.status, TunerStatus.listening);
      expect(s2.noteName, isNull);
      expect(s2.octave, isNull);
      expect(s2.frequency, isNull);
      expect(s2.cents, isNull);
    });

    test('copyWith without clearNote preserves note fields', () {
      const s = TunerState(noteName: 'C', octave: 4, frequency: 261.63, cents: 2.0);
      final s2 = s.copyWith(status: TunerStatus.error);
      expect(s2.noteName, 'C');
      expect(s2.octave, 4);
      expect(s2.frequency, 261.63);
      expect(s2.cents, 2.0);
    });

    test('copyWith preserves referenceA4', () {
      const s = TunerState(referenceA4: 432.0);
      final s2 = s.copyWith(status: TunerStatus.listening);
      expect(s2.referenceA4, 432.0);
    });

    test('copyWith can update referenceA4', () {
      const s = TunerState(referenceA4: 440.0);
      expect(s.copyWith(referenceA4: 432.0).referenceA4, 432.0);
    });
  });
}
