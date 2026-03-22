import 'package:flutter_test/flutter_test.dart';
import 'package:tono/features/metronome/domain/metronome_state.dart';

void main() {
  group('MetronomeState', () {
    test('default values', () {
      const s = MetronomeState();
      expect(s.bpm, 120);
      expect(s.beatsPerBar, 4);
      expect(s.beatUnit, 4);
      expect(s.currentBeat, 0);
      expect(s.status, MetronomeStatus.stopped);
      expect(s.isPlaying, false);
    });

    test('BPM range constants', () {
      expect(MetronomeState.minBpm, 40);
      expect(MetronomeState.maxBpm, 220);
    });

    test('isPlaying is true when status is playing', () {
      final s = const MetronomeState().copyWith(status: MetronomeStatus.playing);
      expect(s.isPlaying, true);
    });

    test('isPlaying is false when status is stopped', () {
      final s =
          const MetronomeState(status: MetronomeStatus.playing).copyWith(
        status: MetronomeStatus.stopped,
      );
      expect(s.isPlaying, false);
    });

    test('copyWith updates only specified fields', () {
      const s = MetronomeState(bpm: 140, beatsPerBar: 3, beatUnit: 8);
      final s2 = s.copyWith(currentBeat: 2);
      expect(s2.bpm, 140);
      expect(s2.beatsPerBar, 3);
      expect(s2.beatUnit, 8);
      expect(s2.currentBeat, 2);
      expect(s2.status, MetronomeStatus.stopped);
    });

    test('copyWith bpm', () {
      const s = MetronomeState();
      expect(s.copyWith(bpm: 80).bpm, 80);
    });

    test('copyWith beatsPerBar', () {
      const s = MetronomeState();
      expect(s.copyWith(beatsPerBar: 6).beatsPerBar, 6);
    });

    test('copyWith beatUnit', () {
      const s = MetronomeState();
      expect(s.copyWith(beatUnit: 8).beatUnit, 8);
    });
  });
}
