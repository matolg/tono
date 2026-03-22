import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tono/core/tool_registry/tool_definition.dart';
import 'package:tono/features/home/presentation/widgets/tool_card.dart';
import 'package:tono/l10n/app_localizations.dart';

// Minimal GoRouter so context.push() doesn't throw.
Widget _buildWithRouter(ToolDefinition tool) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(body: ToolCard(tool: tool)),
      ),
      // target routes for available tools
      GoRoute(path: '/tuner', builder: (context, state) => const Scaffold()),
      GoRoute(path: '/metronome', builder: (context, state) => const Scaffold()),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ru'),
  );
}

const _tuner = ToolDefinition(
  id: 'tuner',
  name: 'Tuner',
  subtitle: 'subtitle',
  icon: Icons.graphic_eq,
  isAvailable: true,
  route: '/tuner',
);

const _unavailable = ToolDefinition(
  id: 'ear_trainer',
  name: 'Ear Trainer',
  subtitle: 'subtitle',
  icon: Icons.music_note,
  isAvailable: false,
  route: '/ear_trainer',
);

void main() {
  group('ToolCard', () {
    testWidgets('available tool shows chevron_right icon', (tester) async {
      await tester.pumpWidget(_buildWithRouter(_tuner));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('unavailable tool shows "Скоро" badge', (tester) async {
      await tester.pumpWidget(_buildWithRouter(_unavailable));
      await tester.pumpAndSettle();
      expect(find.text('Скоро'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('unavailable tool is wrapped in Opacity', (tester) async {
      await tester.pumpWidget(_buildWithRouter(_unavailable));
      await tester.pumpAndSettle();
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, lessThan(1.0));
    });

    testWidgets('available tool is not wrapped in Opacity', (tester) async {
      await tester.pumpWidget(_buildWithRouter(_tuner));
      await tester.pumpAndSettle();
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_buildWithRouter(_tuner));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
