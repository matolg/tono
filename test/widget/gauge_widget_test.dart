import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tono/features/tuner/presentation/widgets/gauge_widget.dart';

Widget _buildWidget(double? cents) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 340,
        height: 177,
        child: GaugeWidget(cents: cents),
      ),
    ),
  );
}

void main() {
  group('GaugeWidget', () {
    testWidgets('renders without error when cents = null (idle)', (tester) async {
      await tester.pumpWidget(_buildWidget(null));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when cents = 0 (in tune)', (tester) async {
      await tester.pumpWidget(_buildWidget(0.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when cents = +50 (sharp)', (tester) async {
      await tester.pumpWidget(_buildWidget(50.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when cents = -50 (flat)', (tester) async {
      await tester.pumpWidget(_buildWidget(-50.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('updates correctly when cents change', (tester) async {
      await tester.pumpWidget(_buildWidget(null));
      await tester.pumpWidget(_buildWidget(0.0));
      await tester.pumpWidget(_buildWidget(-25.0));
      await tester.pumpWidget(_buildWidget(25.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
