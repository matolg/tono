import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tono/features/metronome/presentation/widgets/beat_indicators.dart';

Widget _buildWidget({
  required int beatsPerBar,
  int currentBeat = 0,
  bool isPlaying = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: BeatIndicators(
        beatsPerBar: beatsPerBar,
        currentBeat: currentBeat,
        isPlaying: isPlaying,
      ),
    ),
  );
}

void main() {
  group('BeatIndicators', () {
    testWidgets('renders correct count for 4/4', (tester) async {
      await tester.pumpWidget(_buildWidget(beatsPerBar: 4));
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 4);
    });

    testWidgets('renders correct count for 3/4', (tester) async {
      await tester.pumpWidget(_buildWidget(beatsPerBar: 3));
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 3);
    });

    testWidgets('renders correct count for 6/8', (tester) async {
      await tester.pumpWidget(_buildWidget(beatsPerBar: 6));
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 6);
    });

    testWidgets('renders correct count for 2/4', (tester) async {
      await tester.pumpWidget(_buildWidget(beatsPerBar: 2));
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 2);
    });

    testWidgets('renders without error when isPlaying = false', (tester) async {
      await tester.pumpWidget(
        _buildWidget(beatsPerBar: 4, isPlaying: false, currentBeat: 0),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when isPlaying = true', (tester) async {
      await tester.pumpWidget(
        _buildWidget(beatsPerBar: 4, isPlaying: true, currentBeat: 1),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('tap fires onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeatIndicators(
              beatsPerBar: 4,
              currentBeat: 0,
              isPlaying: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(BeatIndicators));
      expect(tapped, true);
    });
  });
}
