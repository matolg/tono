# План реализации приложения Tono

Каждый шаг — атомарная, завершённая единица работы. Шаги выполняются последовательно. Перед каждым шагом запрашивается разрешение.

**Платформы:** сначала Android (разработка на Windows), iOS — отдельным этапом на macOS после завершения Android-версии.

---

## Шаг 1 — Инструменты разработки

Выписать и проверить всё необходимое для начала работы. Установить самостоятельно, после — перейти к шагу 2.

**IDE и SDK:**
- Flutter SDK 3.19+ (включает Dart 3.3+) → https://docs.flutter.dev/get-started/install
- Android Studio (с Android SDK, SDK Build Tools, эмулятором) → https://developer.android.com/studio
- Git 2.x

**Проверка установки:**
```bash
flutter doctor -v   # достаточно, чтобы Android-тулчейн был зелёным (iOS — пропускаем)
```

**Эмулятор Android:**
- Создать AVD (Pixel 7, API 34) через Android Studio → Device Manager

**Дополнительно (опционально):**
- VS Code + расширения Flutter и Dart (альтернатива Android Studio для редактирования)

---

## Шаг 2 — Минимальный бойлерплейт

Создать Flutter-проект с минимальной рабочей конфигурацией. Должен билдиться и запускаться на Android-эмуляторе.

**Задачи:**
- `flutter create --org com.tono --project-name tono tono` — создание проекта
- Настроить `pubspec.yaml`: добавить все зависимости из T11.2 + `flutter_localizations`
- Настроить `applicationId`: `com.tono.app` (T13)
- Настроить `minSdkVersion 26` в `android/app/build.gradle`
- Ориентация: Portrait only (`AndroidManifest.xml`)
- Создать `lib/main.dart` с `ProviderScope` + заглушкой `App` (пустой `MaterialApp`)
- `flutter pub get` → убедиться, что зависимости резолвятся
- Запустить на Android-эмуляторе
- `git init` + первый коммит

**Результат:** пустой экран с заголовком «Tono», запускается без ошибок на Android.

---

## Шаг 3 — Дизайн-система

Перенести дизайн-токены из `docs/design.pen` в код.

**Задачи:**
- Считать цвета из design.pen и создать `lib/app/theme/app_colors.dart`
- Считать типографику и создать `lib/app/theme/app_text_styles.dart`
- Создать `lib/app/theme/app_theme.dart` — `ThemeData` light + dark (Material 3)
- Подключить тему в `App` (без Riverpod-переключения — просто `ThemeMode.system`)
- Создать `lib/shared/widgets/primary_button.dart`, `segment_control.dart`, `app_bar_widget.dart` — базовые компоненты

**Результат:** тема применена, компоненты работают с правильными цветами/шрифтами.

---

## Шаг 4 — Навигация и Tool Registry

Настроить маршрутизацию и реестр инструментов.

**Задачи:**
- `lib/core/tool_registry/tool_definition.dart` — абстрактный класс
- `lib/core/tool_registry/tool_registry.dart` — реестр (T2.2)
- `lib/app/router.dart` — `GoRouter` с маршрутами `/home`, `/tuner`, `/metronome`, `/settings` (T6)
- `lib/app/app.dart` — `MaterialApp.router` с подключённым роутером
- `lib/features/home/presentation/home_screen.dart` — экран с сеткой карточек из `ToolRegistry.all`
- `lib/features/home/presentation/widgets/tool_card.dart` — карточка инструмента (badge «Скоро» если `isAvailable = false`)
- Заглушки для экранов: `TunerScreen`, `MetronomeScreen`, `SettingsScreen` (просто `Scaffold` с заголовком)
- Регистрация в `main.dart`

**Результат:** навигация работает, на главном экране отображаются карточки инструментов.

---

## Шаг 5 — Локализация

Подключить l10n, вынести все строки в ARB-файлы.

**Задачи:**
- Создать `l10n.yaml` в корне проекта (T8.3)
- Создать `lib/l10n/app_ru.arb` со всеми строками интерфейса (названия экранов, кнопки, подписи, ошибки)
- Создать `lib/l10n/app_en.arb` — перевод на английский
- `flutter gen-l10n` — сгенерировать `AppLocalizations`
- Подключить `localizationsDelegates` и `supportedLocales` в `app.dart`
- Создать `LocaleNotifier` (T8.4) — провайдер локали через `shared_preferences`
- Заменить все хардкод-строки в уже созданных экранах на `AppLocalizations`

**Результат:** приложение переключается между ru/en, все строки локализованы.

---

## Шаг 6 — Хранение данных и тема/локаль через Riverpod

Подключить `shared_preferences`, реализовать переключение темы и языка.

**Задачи:**
- `ThemeModeNotifier` — загружает/сохраняет `theme_mode` из `shared_preferences`
- `themeModeProvider` — подключить в `app.dart`
- `LocaleNotifier` — загружает/сохраняет `app_locale`
- Подключить `localeProvider` в `app.dart`
- Экран настроек (`settings_screen.dart`): переключение темы (Light/Dark/System), выбор языка (ru/en)

**Результат:** смена темы и языка работает и сохраняется между перезапусками.

---

## Шаг 7 — Тюнер: аудиозахват и pitch detection

Реализовать ядро тюнера — от микрофона до ноты.

**Задачи:**
- `lib/core/permissions/permission_service.dart` — запрос разрешения на микрофон
- `lib/core/utils/music_utils.dart` — `frequencyToNote`, `noteNames` (T3.3)
- `lib/features/tuner/domain/tuner_state.dart` — `TunerState`, `TunerStatus` (T3.4)
- `lib/features/tuner/data/pitch_detector.dart` — захват PCM через `record`, YIN/MPM pitch detection в `Isolate`
- `lib/features/tuner/domain/tuner_notifier.dart` — `StateNotifier`, управляет потоком данных из `PitchDetector`
- Разрешения в манифестах: `RECORD_AUDIO` (Android), `NSMicrophoneUsageDescription` (iOS)

**Результат:** `TunerNotifier` корректно возвращает ноту и cents по аудиопотоку.

---

## Шаг 8 — Тюнер: UI

Собрать экран тюнера по дизайну.

**Задачи:**
- `gauge_widget.dart` — `GaugePainter` (CustomPainter): полоса, зоны, needle с анимацией 80ms, сглаживание cents (T3.5)
- `octave_dots.dart` — 5 точек C2–C6, анимация смены 150ms (T3.5)
- `note_display.dart` — большое отображение ноты + октавы + Hz (`font-size/mono-display` 52sp)
- `tuning_reference_selector.dart` — pill-selector A4 (T3.7), ModalBottomSheet со значениями 432–444
- `tuner_screen.dart` — собрать все виджеты, подключить к `TunerNotifier`
- `tuner_module.dart` — `ToolDefinition` для реестра
- Haptic feedback при попадании в tune (`|cents| <= 5`)

**Результат:** экран тюнера полностью функционален согласно дизайну.

---

## Шаг 9 — Метроном: движок

Реализовать точный аудио-движок метронома.

**Задачи:**
- Подготовить аудио-сэмплы: `assets/sounds/metronome_accent.wav`, `assets/sounds/metronome_tick.wav` (WAV 24bit 44100Hz mono)
- `lib/features/metronome/domain/metronome_state.dart` — `MetronomeState` (T4.4)
- `lib/features/metronome/data/metronome_engine.dart` — `MetronomeEngine` через `flutter_soloud` scheduling (T4.1, T4.2)
- `lib/features/metronome/domain/metronome_notifier.dart` — `StateNotifier`, управляет `MetronomeEngine`
- Реализовать `updateBpm()` без перезапуска движка
- Сохранение последних настроек (bpm, beatsPerBar, beatUnit) в `shared_preferences`

**Результат:** метроном бьёт с точностью ±2ms, BPM меняется на лету.

---

## Шаг 10 — Метроном: UI

Собрать экран метронома по дизайну.

**Задачи:**
- `beat_indicators.dart` — N точек по `beatsPerBar`, активная подсвечивается на каждый бит
- `bpm_display.dart` — большое число BPM (`font-size/display` 56sp)
- `bpm_slider.dart` — слайдер 40–220 BPM + кнопки ±1 (long press для быстрого изменения)
- Tap tempo: двойное нажатие на beat indicator, среднее по 4 интервалам (T4.5)
- Segment control: выбор `beatsPerBar` (2–8) и `beatUnit` (4/8) (T4.6)
- `metronome_screen.dart` — собрать все виджеты
- `metronome_module.dart` — `ToolDefinition` для реестра

**Результат:** экран метронома полностью функционален согласно дизайну.

---

## Шаг 11 — Unit и widget тесты

Покрыть критическую логику тестами (T10).

**Задачи:**
- Unit: `MusicUtils.frequencyToNote` — все ноты и октавы
- Unit: `MusicUtils.tempoName` — маппинг BPM → название темпа
- Unit: `MetronomeState` — валидация диапазонов
- Unit: `TunerNotifier` — переходы состояний
- Widget: `GaugeWidget` для cents = -50, 0, +50
- Widget: `BeatIndicators` — количество соответствует `beatsPerBar`
- Widget: `ToolCard` — badge «Скоро» при `isAvailable = false`
- Integration: навигация home → tuner → back → metronome
- Integration: смена темы отражается везде
- Integration: настройки сохраняются между запусками

**Результат:** `flutter test` проходит без ошибок.

---

## Шаг 12 — Финальная проверка и подготовка к публикации

Привести проект в состояние «готов к сборке для TestFlight / Firebase».

**Задачи:**
- Проверить чеклист T14.4
- Иконка приложения во всех нужных размерах (через `flutter_launcher_icons` или вручную)
- Splash screen (опционально, через `flutter_native_splash`)
- Release-сборка: `flutter build apk --release` и `flutter build ios --release`
- Проверить на реальном устройстве (если доступно)
- Убедиться: версия и build number в `pubspec.yaml` выставлены (1.0.0+1)
- Финальный коммит с тегом `v1.0.0`

**Результат:** проект готов к публикации в App Store и Google Play.

---

## Шаг 13 — iOS-порт (после завершения Android)

Выполняется на macOS с установленными Xcode и CocoaPods.

**Задачи:**
- Настроить `IPHONEOS_DEPLOYMENT_TARGET = 15.0` в `ios/Podfile` и Xcode
- Настроить `Bundle ID`: `com.tono.app` в Xcode → Signing & Capabilities
- Ориентация: Portrait only (`Info.plist`)
- Добавить `NSMicrophoneUsageDescription` в `Info.plist`
- Указать `audio` в Background Modes (если метроном работает в фоне)
- Установить CocoaPods и выполнить `pod install` в `ios/`
- Запустить на iOS-симуляторе, проверить все экраны
- Release-сборка: `flutter build ios --release`
- Чеклист T14.2 (App Store) и T14.4

**Результат:** приложение собирается и работает на iOS, готово к отправке в TestFlight.

---

## Статус

| Шаг | Статус |
|-----|--------|
| 1 — Инструменты | ✅ выполнен |
| 2 — Бойлерплейт | ✅ выполнен |
| 3 — Дизайн-система | ✅ выполнен |
| 4 — Навигация и Tool Registry | ⬜ не начат |
| 5 — Локализация | ⬜ не начат |
| 6 — Хранение данных и тема/локаль | ⬜ не начат |
| 7 — Тюнер: аудио и pitch detection | ⬜ не начат |
| 8 — Тюнер: UI | ⬜ не начат |
| 9 — Метроном: движок | ⬜ не начат |
| 10 — Метроном: UI | ⬜ не начат |
| 11 — Тесты | ⬜ не начат |
| 12 — Финальная проверка (Android) | ⬜ не начат |
| 13 — iOS-порт | ⬜ не начат |
