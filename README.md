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

## Релиз

### Android (Google Play)

Требования: [GitHub CLI (`gh`)](https://cli.github.com/) установлен и авторизован (`gh auth login`), git настроен.

#### 1. Выпустить новую версию

```powershell
# Выпустить новую версию (загружается в internal track)
.\scripts\release.ps1          # patch: 1.0.1
.\scripts\release.ps1 minor    # minor: 1.1.0
.\scripts\release.ps1 major    # major: 2.0.0
```

После завершения CI/CD релиз появится во внутреннем треке Play Console.

#### 2. Продвинуть релиз в другой трек

Открыть вкладку **Actions → CD Android → Run workflow** на GitHub и выбрать нужный трек:

| Трек | Описание |
|---|---|
| `internal` | Внутренние тестировщики (до 100 человек) |
| `alpha` | Закрытое тестирование |
| `beta` | Открытое тестирование |
| `production` | Публичный релиз (можно указать rollout fraction, напр. `0.1` = 10%) |

Либо через CLI:

```bash
gh workflow run cd-android.yml -f track=beta
gh workflow run cd-android.yml -f track=production -f rollout=0.1
gh workflow run cd-android.yml -f track=production -f rollout=1.0
```

## Лицензия

MIT — см. [LICENSE](LICENSE)
