# Tono

Мобильное приложение для музыкантов: хроматический тюнер и метроном в одном месте.

## Возможности

- **Тюнер** — хроматический, с pitch detection (YIN/MPM), настройка эталонной частоты A4 (432–444 Hz)
- **Метроном** — точный тайминг (±2ms), BPM 40–220, размеры такта 2–8, tap tempo

## Стек технологий

| Компонент | Технология |
|---|---|
| Framework | Flutter 3.41+ / Dart 3.11+ |
| State Management | Riverpod 3.x |
| Навигация | go_router 17.x |
| Аудио (тюнер) | record 6.x |
| Аудио (метроном) | flutter_soloud 3.x |
| Хранилище | shared_preferences |
| Разрешения | permission_handler |
| Локализация | flutter_localizations + intl (ru, en) |

## Платформы

- Android (minSdk 26 / Android 8.0+) — готово
- iOS (deployment target 15.0+) — планируется

## Запуск

```bash
flutter pub get
flutter run
```

## Лицензия

MIT — см. [LICENSE](LICENSE)
