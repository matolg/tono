// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tono';

  @override
  String get badgeSoon => 'Скоро';

  @override
  String get inDevelopment => 'В разработке';

  @override
  String get toolTunerName => 'Тюнер';

  @override
  String get toolTunerSubtitle => 'Хроматический тюнер';

  @override
  String get toolMetronomeName => 'Метроном';

  @override
  String get toolMetronomeSubtitle => 'Ритм и темп';

  @override
  String get toolEarTrainerName => 'Тренажёр слуха';

  @override
  String get toolEarTrainerSubtitle => 'Интервалы и аккорды';

  @override
  String get toolChordTrainerName => 'Тренажёр аккордов';

  @override
  String get toolChordTrainerSubtitle => 'Гаммы и трезвучия';

  @override
  String get screenTunerTitle => 'Тюнер';

  @override
  String get screenMetronomeTitle => 'Метроном';

  @override
  String get screenSettingsTitle => 'Настройки';

  @override
  String get tunerStartListening => 'Начать слушать';

  @override
  String get tunerStopListening => 'Остановить';

  @override
  String get tunerReferenceA4 => 'Строй';

  @override
  String get tunerReferencePitchTitle => 'Эталон A4';

  @override
  String get tunerNoSignal => 'Нет сигнала';

  @override
  String get tunerListening => 'Слушаю...';

  @override
  String get metronomeStart => 'Старт';

  @override
  String get metronomeStop => 'Стоп';

  @override
  String get metronomeBpmLabel => 'BPM';

  @override
  String get settingsAppearanceSectionHeader => 'Внешний вид';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsAboutTitle => 'О приложении';

  @override
  String get errorMicrophonePermissionDenied => 'Нет доступа к микрофону';
}
