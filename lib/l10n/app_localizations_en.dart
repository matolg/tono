// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tono';

  @override
  String get badgeSoon => 'Soon';

  @override
  String get inDevelopment => 'In development';

  @override
  String get toolTunerName => 'Tuner';

  @override
  String get toolTunerSubtitle => 'Chromatic tuner';

  @override
  String get toolMetronomeName => 'Metronome';

  @override
  String get toolMetronomeSubtitle => 'Rhythm and tempo';

  @override
  String get toolEarTrainerName => 'Ear Trainer';

  @override
  String get toolEarTrainerSubtitle => 'Intervals and chords';

  @override
  String get toolChordTrainerName => 'Chord Trainer';

  @override
  String get toolChordTrainerSubtitle => 'Scales and triads';

  @override
  String get screenTunerTitle => 'Tuner';

  @override
  String get screenMetronomeTitle => 'Metronome';

  @override
  String get screenSettingsTitle => 'Settings';

  @override
  String get tunerStartListening => 'Start listening';

  @override
  String get tunerStopListening => 'Stop';

  @override
  String get tunerReferenceA4 => 'Reference A4';

  @override
  String get tunerNoSignal => 'No signal';

  @override
  String get tunerListening => 'Listening...';

  @override
  String get metronomeStart => 'Start';

  @override
  String get metronomeStop => 'Stop';

  @override
  String get metronomeBpmLabel => 'BPM';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get errorMicrophonePermissionDenied => 'Microphone access denied';
}
