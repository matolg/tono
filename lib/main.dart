import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/providers/locale_notifier.dart';
import 'core/providers/theme_mode_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await Future.wait([
    container.read(localeProvider.notifier).load(),
    container.read(themeModeProvider.notifier).load(),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
