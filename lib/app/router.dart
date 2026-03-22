import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/metronome/presentation/metronome_screen.dart';
import '../features/settings/presentation/language_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tuner/presentation/tuner_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/tuner',
      builder: (context, state) => const TunerScreen(),
    ),
    GoRoute(
      path: '/metronome',
      builder: (context, state) => const MetronomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'language',
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    ),
  ],
);
