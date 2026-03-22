# Техническое задание: Мобильное приложение для музыкантов «Tono»

**Версия документа:** 1.0
**Дата:** 21.03.2026
**Статус:** MVP

---

## Содержание

1. [Общее описание](#1-общее-описание)
2. [Архитектура продукта](#2-архитектура-продукта)
3. [ЧАСТЬ I — Дизайн](#часть-i--дизайн)
4. [ЧАСТЬ II — Техническая разработка](#часть-ii--техническая-разработка)

---

## 1. Общее описание

### 1.1 Назначение

Tono — мобильное приложение для музыкантов, предоставляющее набор инструментов для практики и обучения. Приложение ориентировано на музыкантов любого уровня: от начинающих до профессионалов.

### 1.2 Целевая аудитория

- Начинающие музыканты (гитаристы, вокалисты, духовики, струнники)
- Опытные музыканты, нуждающиеся в портативных инструментах для репетиций
- Педагоги музыки

### 1.3 Платформы

- iOS 15.0+
- Android 8.0+ (API 26+)

### 1.4 MVP — состав инструментов

| Инструмент | Статус в MVP |
|---|---|
| Тюнер (Chromatic Tuner) | ✅ Включён |
| Метроном (Metronome) | ✅ Включён |
| Тренажёр слуха | 🔜 Следующий этап |
| Тренажёр аккордов | 🔜 Следующий этап |
| Тренажёр ритма | 🔜 Следующий этап |
| Дневник практики | 🔜 Следующий этап |

---

## 2. Архитектура продукта

### 2.1 Концепция расширяемости (Tool Registry)

Все инструменты приложения проектируются как независимые модули, регистрируемые в центральном реестре. Добавление нового инструмента не требует изменений в существующем коде — достаточно зарегистрировать новый модуль.

```
Инструменты (Tools)
├── Тюнер          [MVP]
├── Метроном       [MVP]
├── Тренажёр...    [future]
└── ...            [future]
```

### 2.2 Навигация

- Главный экран — список всех доступных инструментов
- Каждый инструмент открывается как отдельный полноэкранный раздел
- Переход в настройки — через иконку ⚙️ в правом углу App Bar главного экрана
- Нижняя навигация отсутствует

---

---

# ЧАСТЬ I — ДИЗАЙН

> Этот раздел описывает реализованную дизайн-систему и спецификации экранов приложения. Макеты выполнены в Pencil (`docs/design.pen`) — 8 экранов в двух темах (Light + Dark). Все значения привязаны к переменным дизайн-системы.

---

## D1. Дизайн-система

### D1.1 Философия дизайна

- **Стиль:** современный минимализм с тёплой тональностью
- **Принципы:** чистота, воздух, фокус на содержании
- **Настроение:** спокойное, вдохновляющее, профессиональное
- Никаких лишних декоративных элементов; UI уходит на второй план, когда инструмент активен

### D1.2 Цветовая палитра

Палитра построена на тёплых нейтральных тонах с терракотовым primary. Все токены существуют в двух вариантах: светлая и тёмная тема. Тёмная тема — самостоятельная схема, elevation передаётся через более светлый оттенок поверхности, без теней.

#### Базовые поверхности

| Токен | Light | Dark | Роль |
|---|---|---|---|
| `color/background` | `#F5F4F1` | `#1C1A18` | Основной фон экранов |
| `color/surface` | `#FFFFFF` | `#252320` | Фон карточек и секций |
| `color/surface-variant` | `#EDECEA` | `#2E2B28` | Неактивные контейнеры, поля ввода |
| `color/divider` | `#E5E4E1` | `#2E2B28` | Разделители |

#### Primary

| Токен | Light | Dark | Роль |
|---|---|---|---|
| `color/primary` | `#C4856A` | `#D4957A` | Кнопки, активные элементы, needle |
| `color/primary-container` | `#F5E0D8` | `#3D2A24` | Фон иконок инструментов |

#### Текст

| Токен | Light | Dark | Роль |
|---|---|---|---|
| `color/text-primary` | `#1A1918` | `#F0EDE8` | Основной текст |
| `color/text-secondary` | `#6D6C6A` | `#8A8380` | Вторичный текст, подписи, неактивные элементы |
| `color/text-tertiary` | `#FFFFFF` | `#FFFFFF` | Текст на цветных фонах (кнопки, активный сегмент) |

#### Состояния и системные цвета

| Токен | Light | Dark | Роль |
|---|---|---|---|
| `color/error` | `#D08068` | `#E09078` | Ошибки |

#### Gauge (тюнер)

Три зоны отклонения, все в пастельном регистре:

| Токен | Light | Dark | Условие |
|---|---|---|---|
| `color/gauge-in-tune` | `#B8E8C4` | `#4A9860` | ±5 cents — попадание в ноту |
| `color/gauge-close` | `#EEE5A0` | `#8A8030` | ±5–20 cents — близко |
| `color/gauge-off` | `#F5BDB5` | `#904040` | ±20–50 cents — далеко |

### D1.3 Типографика

**Основной шрифт:** Inter
**Дополнительный (цифровые показания):** JetBrains Mono

| Токен | Шрифт | Размер | Weight | Использование |
|---|---|---|---|---|
| `font-size/display` | Inter | 56sp | 300 Light | BPM (большое числовое показание) |
| `font-size/headline-l` | Inter | 26sp | 600 SemiBold | Заголовки крупных секций |
| `font-size/headline-m` | Inter | 18sp | 600 SemiBold | Заголовки секций |
| `font-size/body-l` | Inter | 16sp | 400 Regular | Основной текст, кнопки |
| `font-size/body-m` | Inter | 14sp | 500 Medium | Элементы управления, сегменты |
| `font-size/body-sm` | Inter | 13sp | 400 Regular | Вторичный текст |
| `font-size/label` | Inter | 12sp | 500 Medium | Подписи, метки |
| `font-size/caption` | Inter | 11sp | 400 Regular | Мелкие подписи |
| `font-size/mono-display` | JetBrains Mono | 52sp | 400 Regular | Нота / частота в тюнере |
| `font-size/mono-label` | JetBrains Mono | 18sp | 400 Regular | Числовые значения (Hz) |

### D1.4 Иконография

- Стиль: Line icons, скруглённые концы
- Размеры (токены): `icon-size/sm`=16px, `icon-size/md`=20px, `icon-size/lg`=24px, `icon-size/xl`=28px
- Цвет: `color/text-primary` (обычные), `color/primary` (акцентные)

### D1.5 Отступы и сетка

Отступы строятся на 4px-сетке. Доступные токены:

`spacing/4` · `spacing/8` · `spacing/12` · `spacing/16` · `spacing/20` · `spacing/24` · `spacing/32` · `spacing/40`

- Горизонтальные отступы экрана: `spacing/20` (20px)
- Расстояние между карточками: `spacing/12` (12px)
- Расстояние между секциями: `spacing/24` (24px)
- Safe area: Dynamic Island (iOS) и нотчи (Android) учтены

### D1.6 Скругления

| Токен | Значение | Применение |
|---|---|---|
| `radius/xs` | 8px | Badge, мелкие элементы |
| `radius/sm` | 12px | Beat indicators, внутренние элементы |
| `radius/md` | 14px | Кнопки, карточки, секции настроек |
| `radius/lg` | 20px | Крупные карточки |
| `radius/xl` | 24px | — |
| `radius/full` | 100px | Pill-элементы (segment control, badge) |

### D1.7 Анимации

| Токен | Значение | Применение |
|---|---|---|
| `animation/micro` | 80ms | Beat indicator (пульс) |
| `animation/fast` | 150ms | Нажатие кнопок |
| `animation/default` | 200ms | Segment control, переключения |
| `animation/medium` | 300ms | Переходы между экранами |
| `animation/scale-pressed` | 0.96 | Scale при нажатии |
| `animation/scale-beat` | 1.12 | Scale beat indicator при активации |

- Все анимации должны уважать системную настройку «Reduce Motion»

### D1.8 Размеры компонентов

| Токен | Значение | Компонент |
|---|---|---|
| `component/status-bar` | 54px | Статус-бар |
| `component/app-bar` | 56px | Навигационная панель |
| `component/button-height` | 60px | Primary Button |
| `component/button-height-sm` | 40px | Малая кнопка |
| `component/card-height` | 100px | Tool Card |
| `component/icon-container` | 52px | Контейнер иконки инструмента |
| `component/segment-height` | 40px | Segment Control (внешний) |
| `component/segment-item-height` | 32px | Активный сегмент (внутренний) |
| `component/beat-accent` | 56px | Beat indicator (акцент, первая доля) |
| `component/beat-default` | 48px | Beat indicator (обычная доля) |
| `component/slider-track` | 4px | Слайдер — дорожка |
| `component/slider-thumb` | 22px | Слайдер — thumb |
| `component/touch-target` | 44px | Минимальная зона касания |

---

## D2. Компоненты UI

### D2.1 Tool Card (карточка инструмента)

```
┌─────────────────────────────────────┐
│  ┌──────┐                           │
│  │ icon │  Название инструмента  →  │
│  └──────┘  Краткое описание         │
└─────────────────────────────────────┘
```

- Размер: ширина fill, высота `component/card-height` (100px)
- Background: `color/surface`
- Corner radius: `radius/md` (14px)
- Иконка-контейнер: 52×52px (`component/icon-container`), corner radius `radius/md`, фон `color/primary-container`
- Название: `font-size/headline-m`, `color/text-primary`
- Описание: `font-size/body-sm`, `color/text-secondary`
- Стрелка → : `icon-size/md` (20px), `color/text-secondary`

**Состояния:**
- Default
- Pressed (scale `animation/scale-pressed`)
- Disabled — badge «Скоро» поверх карточки

### D2.2 Badge «Скоро»

- Pill-форма, corner radius `radius/full`
- Background: `color/surface-variant`
- Text: «Скоро», `font-size/label`, `color/text-primary`

### D2.3 Primary Button (Action Button)

- Высота: `component/button-height` (60px)
- Corner radius: `radius/md` (14px)
- Background: `color/primary`
- Text + иконка: `color/text-tertiary` (белый), `font-size/body-l`
- States: Default / Pressed (scale `animation/scale-pressed`) / Disabled (opacity `opacity/disabled`)

### D2.4 Navigation Button

- Размер: `component/touch-target` × `component/touch-target` (44×44px)
- Corner radius: `radius/md`
- Background: прозрачный
- Иконка: `icon-size/md` (20px), `color/text-primary`

### D2.5 Slider (BPM)

- Track height: `component/slider-track` (4px), цвет дорожки: `color/surface-variant`
- Заполненная часть: `color/primary`
- Thumb: `component/slider-thumb` (22px), `color/primary`

### D2.6 Segment Control

- Внешний контейнер: высота `component/segment-height` (40px), фон `color/surface-variant`, corner radius `radius/full`
- Активный сегмент: высота `component/segment-item-height` (32px), фон `color/primary`, corner radius `radius/full`
- Текст активного сегмента: `color/text-tertiary` (белый)
- Текст неактивных сегментов: `color/text-secondary`
- Переключение: анимация `animation/default` (200ms)
- Компонент поддерживает произвольное количество сегментов (3 для выбора темы, 5 для размера такта)

### D2.7 Tuning Reference Selector (Selector строя)

```
[ Строй: A = 440                ▾ ]
```

- Форма: pill (горизонтальная строка), ширина 276px (совпадает с Segment Control), corner radius `radius/full`
- Высота: `component/segment-height` (40px)
- Фон: `color/surface-variant` — идентичен фону Segment Control
- Текст «Строй: A = 440»: `font-size/body-m`, `color/text-primary`, прижат к левому краю (padding-left `spacing/16`)
- Шеврон ▾: `icon-size/sm` (16px), `color/text-secondary`, прижат к правому краю (padding-right `spacing/16`)
- Между текстом и иконкой: fill-spacer
- Выравнивание: центрировать горизонтально на экране (отступ (390−276)/2 = 57px с каждой стороны)
- Тап: открывает bottom sheet или picker с вариантами эталонной частоты (432, 440, 441, 442, 443, 444 Hz)

---

## D3. Экраны

### D3.1 Главный экран

**Layout (сверху вниз):**

```
┌──────────────────────────────────┐
│  Tono                       ⚙️   │  ← Заголовок + кнопка настроек
├──────────────────────────────────┤
│  ┌────────────────────────────┐  │
│  │  🎵  Тюнер            →   │  │  ← Tool Card (активная)
│  │      Хроматический тюнер   │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │  🥁  Метроном          →   │  │  ← Tool Card (активная)
│  │      Ритм и темп            │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │  🎧  Тренажёр слуха  Скоро │  │  ← Tool Card (disabled)
│  │      Интервалы и аккорды    │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │  🎸  Тренажёр аккордов Скоро│  │  ← Tool Card (disabled)
│  │      Гаммы и трезвучия      │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
```

- Фон экрана: `color/background`
- Карточки с отступом `spacing/20` от краёв, расстояние между карточками `spacing/12`

---

### D3.2 Экран тюнера

**Layout (сверху вниз):**

```
┌──────────────────────────────────┐
│ ←              Тюнер        ⚙️  │  ← App Bar
├──────────────────────────────────┤
│                                  │
│         C#  /  D♭                │  ← Нота, Mono Display 48sp
│          261.6 Hz                │  ← Частота, Mono Label 18sp
│                                  │
│  ┌────────────────────────────┐  │
│  │ -50          0        +50  │  │
│  │  ══════════════│════════   │  │  ← Gauge (горизонтальная полоса)
│  │                │           │  │    │ = needle (текущая позиция)
│  │                            │  │
│  │     ●    ●   [●]   ●   ●  │  │  ← Октавные точки C2–C6 (5 шт.)
│  └────────────────────────────┘  │
│                                  │
│  [ Строй: A = 440          ▾ ]  │  ← Tuning Reference Selector
│                                  │
│  ┌──────────────────────────┐   │
│  │  🎙  Начать слушать      │   │  ← Primary Button
│  └──────────────────────────┘   │
└──────────────────────────────────┘
```

**Gauge Frame (карточка):**
- Фон: `color/surface`, corner radius `radius/md` (14px)
- Внутренние отступы: `spacing/20` по горизонтали, `spacing/16` по вертикали
- Содержимое (сверху вниз внутри карточки):
  1. Gauge Bar + Needle + Маркеры
  2. Октавные точки

**Gauge Bar:**
- Форма: горизонтальная полоса (linear bar), высота 12dp, corner radius `radius/sm`
- Диапазон: −50…+50 cents (линейный масштаб)
- Цветовые зоны полосы (симметрично от центра):
  - ±0–5 cents: `color/gauge-in-tune` (центр, зелёный)
  - ±5–20 cents: `color/gauge-close` (жёлтый)
  - ±20–50 cents: `color/gauge-off` (красный, края)
- Needle: вертикальная линия `color/primary`, позиция = cents → горизонтальное смещение
- Маркеры: `−50`, `0`, `+50` под полосой, `color/text-secondary`

**Октавные точки:**
- 5 точек, соответствующих октавам C2–C6
- Расположены в нижней части Gauge Frame, горизонтально, по центру
- Активная октава (текущая нота): увеличенная точка, `color/primary`
- Неактивные: `color/surface-variant`
- Реализация: аналогична PageIndicator (5 кружков с анимацией смены)

**Состояния тюнера:**

| Состояние | Описание |
|---|---|
| Idle | Gauge в нейтральной позиции |
| Listening | Gauge активен, кнопка меняет состояние |
| Note detected | Нота и частота отображаются, стрелка двигается |
| In tune | Needle и центральная зона переходят в `color/gauge-in-tune` + `HapticFeedback.lightImpact()` |

---

### D3.3 Экран метронома

**Layout (сверху вниз):**

```
┌──────────────────────────────────┐
│ ←           Метроном        ⚙️  │  ← App Bar
├──────────────────────────────────┤
│                                  │
│  ┌──┐  ┌──┐  ┌──┐  ┌──┐        │  ← Beat Indicators
│  │●  │  │○ │  │○ │  │○ │        │    (кол-во = числитель размера)
│  └──┘  └──┘  └──┘  └──┘        │
│                                  │
│              120                 │  ← BPM, Display 56sp
│              BPM                 │  ← Label 12sp
│                                  │
│  ━━━━━━━━●━━━━━━━━━━━━━━━━━━━   │  ← BPM Slider (40–220)
│  40                         220  │
│                                  │
│  [  −  ]    Allegro    [  +  ]  │  ← ±1 BPM + название темпа
│                                  │
│  [ 2/4  3/4  4/4  5/4  6/8 ]   │  ← Segment Control (размер такта)
│                                  │
│  ┌──────────────────────────┐   │
│  │  ▶  Старт                │   │  ← Primary Button
│  └──────────────────────────┘   │
└──────────────────────────────────┘
```

**Beat Indicators:**
- Количество = числитель выбранного размера
- Форма: скруглённые квадраты, corner radius `radius/sm`
- Первая доля (акцент): `component/beat-accent` (56px), `color/primary` при активации
- Остальные доли: `component/beat-default` (48px), `color/primary` при активации
- Неактивное состояние: `color/surface-variant`
- Анимация: scale `animation/scale-beat` (1.12) + fade, `animation/micro` (80ms)

**Размер такта (Segment Control):**
- 5 сегментов: 2/4 · 3/4 · **4/4** · 5/4 · 6/8
- 4/4 выбран по умолчанию
- Реализован как экземпляр компонента Segment Control с 5 активными слотами

**Названия темпов:**

| BPM | Название |
|---|---|
| 40–60 | Largo |
| 60–66 | Larghetto |
| 66–76 | Adagio |
| 76–108 | Andante |
| 108–120 | Moderato |
| 120–156 | Allegro |
| 156–176 | Vivace |
| 176–200 | Presto |
| 200–220 | Prestissimo |

---

### D3.4 Экран настроек

**Layout (сверху вниз):**

```
┌──────────────────────────────────┐
│ ←           Настройки            │  ← App Bar
├──────────────────────────────────┤
│                                  │
│  Внешний вид                     │  ← Заголовок секции
│  ┌────────────────────────────┐  │
│  │  Тема  [Светлая Тёмная Системная]  │  ← Segment Control (3 сегмента)
│  └────────────────────────────┘  │
│                                  │
│  Язык                            │  ← Заголовок секции
│  ┌────────────────────────────┐  │
│  │  Язык              Русский ›│  │  ← Строка выбора языка
│  └────────────────────────────┘  │
│                                  │
│  О приложении                    │
│  ┌────────────────────────────┐  │
│  │  Версия               1.0.0│  │
│  │  ─────────────────────────│  │
│  │  Политика конфиденциальности →│
│  └────────────────────────────┘  │
│                                  │
└──────────────────────────────────┘
```

**Секции:**
- Фон: `color/surface`, corner radius `radius/md`
- Заголовки секций: `color/text-secondary`, `font-size/body-sm`
- Разделители внутри секций: `color/divider`
- Текст строк: `color/text-primary` (метка), `color/text-secondary` (значение/иконка)

**Секция «Язык»:**
- Строка с меткой «Язык» слева и текущим языком («Русский») + шеврон справа
- Тап открывает picker со списком доступных языков
- Первоначально поддерживаемые языки: Русский, English (расширяется при необходимости)

---

## D4. Доступность и статус дизайна

### D4.1 Accessibility

- Контраст текста: WCAG AA (≥4.5:1) проверен на всех экранах обеих тем
- `color/text-secondary` (#6D6C6A на #EDECEA): 4.6:1 ✅
- `color/text-secondary-dark` (#8A8380 на #252320): 4.5:1 ✅
- Минимальная зона касания: `component/touch-target` (44px) для всех интерактивных элементов
- Поддержка Dynamic Type и Screen Reader — в задаче на разработку

### D4.2 Статус макетов

- [x] Дизайн-система с переменными (Pencil: `docs/design.pen`)
- [x] Все экраны в двух темах: Home, Tuner, Metronome, Settings (с секциями Внешний вид / Язык / О приложении) × Light + Dark
- [x] Компоненты: Action Button, Segment Control, Navigation Button, Home Card
- [x] Все цвета, размеры, отступы привязаны к токенам дизайн-системы
- [ ] Прототип с переходами (следующий этап)
- [ ] Export assets: иконки SVG
- [ ] Анимационные спецификации (timing, easing)

---

---

# ЧАСТЬ II — ТЕХНИЧЕСКАЯ РАЗРАБОТКА

> Этот раздел предназначен для команды разработки Flutter и полностью описывает архитектуру, модули, API и требования к реализации.

---

## T1. Технический стек

| Компонент | Технология |
|---|---|
| Framework | Flutter 3.19+ (Dart 3.3+) |
| State Management | Riverpod 2.x |
| Навигация | go_router 13.x |
| Локальное хранилище | shared_preferences / Hive |
| Аудио (тюнер) | record + fft (pitchy или custom DSP) |
| Аудио (метроном) | flutter_soloud или audioplayers |
| Разрешения | permission_handler |
| Тема | ThemeData + ThemeMode, Material 3 |
| Локализация | flutter_localizations (SDK), intl 0.19+ |
| Тестирование | flutter_test, mocktail |
| CI/CD | GitHub Actions / Fastlane |

---

## T2. Архитектура приложения

### T2.1 Общая структура

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # MaterialApp, тема, роутинг
│   ├── router.dart               # go_router конфигурация
│   └── theme/
│       ├── app_theme.dart        # ThemeData light + dark
│       ├── app_colors.dart       # Цветовые константы (из docs/design.pen)
│       └── app_text_styles.dart  # Типографика (из docs/design.pen)
│
├── l10n/
│   ├── app_ru.arb                # Строки: Русский (шаблон)
│   ├── app_en.arb                # Строки: English
│   └── # app_localizations.dart — auto-generated (flutter gen-l10n)
│
├── core/
│   ├── tool_registry/
│   │   ├── tool_registry.dart    # Реестр инструментов
│   │   └── tool_definition.dart  # Модель описания инструмента
│   ├── permissions/
│   │   └── permission_service.dart
│   └── utils/
│       └── music_utils.dart      # Музыкальные константы и утилиты
│
├── features/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       └── tool_card.dart
│   │   └── home_module.dart
│   │
│   ├── tuner/
│   │   ├── data/
│   │   │   └── pitch_detector.dart
│   │   ├── domain/
│   │   │   ├── tuner_state.dart
│   │   │   └── tuner_notifier.dart
│   │   ├── presentation/
│   │   │   ├── tuner_screen.dart
│   │   │   └── widgets/
│   │   │       ├── gauge_widget.dart          # GaugeCard + GaugePainter
│   │   │       ├── octave_dots.dart           # OctaveDotsWidget (C2–C6)
│   │   │       ├── note_display.dart
│   │   │       └── tuning_reference_selector.dart
│   │   └── tuner_module.dart     # Точка регистрации модуля
│   │
│   ├── metronome/
│   │   ├── data/
│   │   │   └── metronome_engine.dart
│   │   ├── domain/
│   │   │   ├── metronome_state.dart
│   │   │   └── metronome_notifier.dart
│   │   ├── presentation/
│   │   │   ├── metronome_screen.dart
│   │   │   └── widgets/
│   │   │       ├── beat_indicators.dart
│   │   │       ├── bpm_display.dart
│   │   │       └── bpm_slider.dart
│   │   └── metronome_module.dart
│   │
│   └── settings/
│       ├── domain/
│       │   └── settings_notifier.dart
│       └── presentation/
│           └── settings_screen.dart
│
└── shared/
    └── widgets/
        ├── primary_button.dart
        ├── segment_control.dart
        └── app_bar_widget.dart
```

### T2.2 Tool Registry (расширяемость)

Ключевой паттерн для добавления новых инструментов без изменения существующего кода.

```dart
// core/tool_registry/tool_definition.dart

abstract class ToolDefinition {
  String get id;
  String get name;
  String get description;
  IconData get icon;
  bool get isAvailable; // false = "Coming soon"
  String get routePath;
}

// core/tool_registry/tool_registry.dart

class ToolRegistry {
  static final List<ToolDefinition> _tools = [];

  static void register(ToolDefinition tool) {
    _tools.add(tool);
  }

  static List<ToolDefinition> get all => List.unmodifiable(_tools);
  static List<ToolDefinition> get available =>
      _tools.where((t) => t.isAvailable).toList();
}
```

```dart
// main.dart

void main() {
  // Регистрация инструментов MVP
  ToolRegistry.register(TunerModule.definition);
  ToolRegistry.register(MetronomeModule.definition);
  // Новый инструмент добавляется одной строкой:
  // ToolRegistry.register(EarTrainerModule.definition);

  runApp(const ProviderScope(child: App()));
}
```

---

## T3. Модуль тюнера

### T3.1 Принцип работы

1. Запрос разрешения на микрофон
2. Захват аудиопотока с микрофона (PCM float32, sample rate 44100 Hz)
3. Применение оконной функции (Hamming window) к буферу
4. FFT-анализ буфера (размер 4096–8192 samples)
5. Определение фундаментальной частоты (pitch detection)
6. Конвертация Hz → нота + центы отклонения
7. Передача состояния в UI через Riverpod

### T3.2 Алгоритм pitch detection

Рекомендуется использовать алгоритм **YIN** или **MPM (McLeod Pitch Method)** для точности на низких частотах.

Fallback: автокорреляция + парабольная интерполяция пика FFT.

```dart
// Рекомендуемый пакет: питч-детекция
// Вариант 1: flutter_pitchy (если актуален)
// Вариант 2: реализация YIN на Dart с использованием compute() для изоляции
```

### T3.3 Конвертация частоты в ноту

```dart
// core/utils/music_utils.dart

class MusicUtils {
  /// A4 = 440 Hz (настраивается пользователем: 432, 440, 441, 442, 443, 444)
  static const double defaultA4 = 440.0;

  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  /// Возвращает ноту и отклонение в центах
  static ({String note, int octave, double cents}) frequencyToNote(
    double frequency, {double a4 = defaultA4}
  ) {
    final semitones = 12 * log(frequency / a4) / log(2);
    final roundedSemitones = semitones.round();
    final cents = (semitones - roundedSemitones) * 100;

    // A4 = MIDI 69
    final midiNote = 69 + roundedSemitones;
    final noteIndex = midiNote % 12;
    final octave = (midiNote ~/ 12) - 1;

    return (
      note: noteNames[noteIndex],
      octave: octave,
      cents: cents,
    );
  }
}
```

### T3.4 TunerState

```dart
// features/tuner/domain/tuner_state.dart

enum TunerStatus { idle, listening, detected, noSignal }

class TunerState {
  final TunerStatus status;
  final String? noteName;
  final int? octave;
  final double? frequency;
  final double cents;      // -50.0 до +50.0
  final double a4Reference; // 432–444 Hz
  final bool isInTune;     // |cents| <= 5

  const TunerState({...});
}
```

### T3.5 Gauge Widget — требования к реализации

Gauge Frame является карточкой (`color/surface`, `radius/md`), внутри которой располагаются два виджета:
1. `GaugeWidget` — сама полоса с needle и маркерами
2. `OctaveDotsWidget` — ряд из 5 точек (C2–C6)

```dart
// features/tuner/presentation/widgets/gauge_widget.dart

// Карточка-контейнер (GaugeCard):
//   Container(decoration: BoxDecoration(color: surface, borderRadius: radius/md))
//   │
//   ├─ GaugePainter (CustomPainter):
//   │   - Горизонтальная полоса RRect, высота 12dp, cornerRadius radius/sm
//   │   - Зоны (слева направо, симметрично): gauge-off | gauge-close | gauge-in-tune | gauge-close | gauge-off
//   │     Границы: ±5 cents и ±20 cents (в пространстве пикселей)
//   │   - Needle: вертикальная линия 2dp, color/primary
//   │     позиция = lerpDouble(0, barWidth, (cents + 50) / 100)
//   │   - Маркеры под полосой: '−50', '0', '+50', color/text-secondary
//   │   - При isInTune: needle цвет gauge-in-tune + HapticFeedback.lightImpact()
//   │
//   └─ OctaveDotsWidget:
//       - 5 точек горизонтально, по центру, внизу карточки
//       - Активная (текущая октава): size 14dp, color/primary
//       - Неактивные: size 10dp, color/surface-variant
//       - Анимация смены октавы: animation/fast (150ms)
```

**Параметры Gauge Bar:**
- Высота полосы: 12dp
- Corner radius полосы: `radius/sm` (12px)
- Ширина: fill (по ширине контейнера с учётом внутренних отступов `spacing/20`)
- Диапазон: −50…+50 cents, линейный
- Needle: ширина 2dp, цвет `color/primary`, высота = высота полосы
- Анимация needle: `AnimationController`, duration `animation/micro` (80ms), `Curves.easeOut`
- Сглаживание входных данных: скользящее среднее по 3–5 последним значениям cents

**OctaveDotsWidget:**
- 5 точек → октавы C2, C3, C4, C5, C6
- Точка определяется через `octave` из `TunerState`
- `currentOctave` подсвечивает соответствующую точку: `color/primary`, size 14dp
- Остальные: `color/surface-variant`, size 10dp

### T3.6 Разрешения

```yaml
# android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

# ios/Runner/Info.plist
NSMicrophoneUsageDescription: "Tono использует микрофон для определения высоты ноты"
```

### T3.7 TuningReferenceSelector

```dart
// features/tuner/presentation/widgets/tuning_reference_selector.dart

// Pill-selector для выбора эталонной частоты A4.
// Визуально идентичен Segment Control по ширине и фону.
//
// Параметры:
//   - Ширина: 276px (фиксированная, совпадает с Segment Control)
//   - Выравнивание: центрировать горизонтально (margin horizontal 57px)
//   - Высота: component/segment-height (40px)
//   - Фон: color/surface-variant
//   - Corner radius: radius/full
//   - Содержимое: Row [Text(fill) | Icon(chevron_down)]
//     · Text: 'Строй: A = $a4Reference', font-size/body-m, color/text-primary
//     · Icon: icon-size/sm (16px), color/text-secondary, padding-right spacing/16
//
// Значения a4Reference: [432, 440, 441, 442, 443, 444] Hz
// По умолчанию: 440 Hz (из TunerState.a4Reference)
// Тап → showModalBottomSheet или CupertinoPicker со списком значений
```

---

## T4. Модуль метронома

### T4.1 Принцип работы

- Метроном должен работать с точностью ±2ms от заданного BPM
- Реализация через **изолированный аудио-поток** (не Timer/Future — они не дают нужной точности)
- Рекомендация: `flutter_soloud` для low-latency воспроизведения сэмплов или native platform channel с AudioTrack (Android) / AVAudioEngine (iOS)

### T4.2 Архитектура движка

```dart
// features/metronome/data/metronome_engine.dart

class MetronomeEngine {
  // Запуск в Isolate или через platform channel
  // Входные параметры: bpm, beatsPerBar, accentFirstBeat
  // Выходные события: Stream<BeatEvent>

  Stream<BeatEvent> get beatEvents;

  Future<void> start({required int bpm, required int beatsPerBar});
  Future<void> stop();
  Future<void> updateBpm(int bpm); // без перезапуска
  Future<void> updateBeatsPerBar(int beats);
  Future<void> dispose();
}

class BeatEvent {
  final int beatIndex;  // 0-based
  final bool isAccent;  // true для первой доли
  final DateTime timestamp;
}
```

### T4.3 Звуки метронома

- Сэмплы в форматах WAV (24bit, 44100Hz, mono)
- **Акцентная доля (beat 0):** чёткий «клик», более высокий и громкий
- **Остальные доли:** «тик», более низкий
- Файлы: `assets/sounds/metronome_accent.wav`, `assets/sounds/metronome_tick.wav`
- Опционально в будущем: выбор звука (дерево, электронный, пикколо...)

### T4.4 MetronomeState

```dart
// features/metronome/domain/metronome_state.dart

class MetronomeState {
  final bool isPlaying;
  final int bpm;             // 40–220
  final int beatsPerBar;     // 2, 3, 4, 5, 6, 7, 8
  final int beatUnit;        // 4 или 8 (четверть/восьмая)
  final int currentBeat;     // 0-based, текущая доля
  final String tempoName;    // "Allegro", "Andante"...

  const MetronomeState({...});
}
```

### T4.5 BPM — диапазон и ввод

- Диапазон: 40–220 BPM
- Slider: непрерывный
- Кнопки ±1 BPM (с поддержкой long press для быстрого изменения)
- Tap tempo: двойное нажатие на beat indicator — вычисляется BPM по интервалам между нажатиями (среднее по 4 последним)
- Изменение BPM во время воспроизведения применяется немедленно, без перезапуска

### T4.6 Размер такта

| Числитель | Знаменатель |
|---|---|
| 2, 3, 4, 5, 6, 7, 8 | 4, 8 |

---

## T5. Управление темой

> **Источник токенов дизайна:** Все цветовые константы, типографика, отступы и радиусы кодируются строго из файла `docs/design.pen`. При обновлении дизайна токены обновляются в `app_colors.dart` / `app_text_styles.dart` вручную либо через export-скрипт — самостоятельно значения не придумываются. Pencil-файл является единственным источником правды для дизайн-токенов.

```dart
// app/theme/app_theme.dart

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      primary: AppColors.primary,
      // ...
    ),
    textTheme: AppTextStyles.textTheme,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      background: AppColors.darkBackground,
      // ...
    ),
    textTheme: AppTextStyles.textTheme,
  );
}

// Провайдер темы (Riverpod)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
```

---

## T6. Навигация

```dart
// app/router.dart (go_router)

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/tuner', builder: (_, __) => const TunerScreen()),
    GoRoute(path: '/metronome', builder: (_, __) => const MetronomeScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    // Новые инструменты добавляются здесь
  ],
);
```

---

## T7. Хранение данных

Все настройки пользователя сохраняются локально через `shared_preferences`.

| Ключ | Тип | Default | Описание |
|---|---|---|---|
| `theme_mode` | String | `system` | `light` / `dark` / `system` |
| `app_locale` | String? | `null` | Выбранный язык (`ru`, `en`); `null` = системный |
| `tuner_a4_reference` | int | `440` | Эталонная частота |
| `metronome_bpm` | int | `120` | Последний BPM |
| `metronome_beats_per_bar` | int | `4` | Последний размер |
| `metronome_beat_unit` | int | `4` | Знаменатель размера |

---

## T8. Локализация

### T8.1 Подход

Локализация реализуется через официальный механизм Flutter: `flutter_localizations` + `intl` + ARB-файлы с автогенерацией (`flutter gen-l10n`). Это обеспечивает:
- Добавление нового языка без изменений в существующем коде приложения
- Поддержку plurals, числовых и датовых форматов
- Совместимость со стандартными инструментами перевода (Weblate, Lokalise и др.)

### T8.2 MVP — поддерживаемые языки

| Код | Язык | Файл |
|---|---|---|
| `ru` | Русский | `lib/l10n/app_ru.arb` |
| `en` | English | `lib/l10n/app_en.arb` |

### T8.3 Конфигурация

```yaml
# pubspec.yaml
flutter:
  generate: true  # включает flutter gen-l10n

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

```yaml
# l10n.yaml (в корне проекта)
arb-dir: lib/l10n
template-arb-file: app_ru.arb
output-localization-file: app_localizations.dart
```

```dart
// app/app.dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: ref.watch(localeProvider), // null = системный
  ...
)
```

### T8.4 Провайдер локали

```dart
// Riverpod-провайдер для выбранного языка
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale?> {
  // null = следовать системному языку
  // Locale('ru') / Locale('en') — принудительно
  LocaleNotifier() : super(_loadFromPrefs());
  void setLocale(Locale? locale) { ... } // сохраняет в shared_preferences
}
```

### T8.5 Добавление нового языка

Для добавления нового языка достаточно:
1. Создать `lib/l10n/app_<code>.arb` с переводами всех ключей из шаблона
2. Добавить `Locale('<code>')` в `supportedLocales` в `app.dart`
3. Добавить опцию в экран настроек (список доступных языков)

**Изменений в бизнес-логике не требуется.**

### T8.6 Строки интерфейса

Все текстовые строки UI — названия экранов, кнопок, подписей, сообщений об ошибках — должны быть вынесены в ARB-файлы. Жёстко закодированные строки на русском или английском не допускаются.

---

## T9. Производительность и ограничения

### T9.1 Аудио

- Тюнер: аудиобуфер обрабатывается в `Isolate` или через native plugin, не в main isolate
- Метроном: timing реализован на нативном уровне (Platform Channel) или через `flutter_soloud` scheduling
- Оба инструмента: при переходе в фон аудио останавливается (тюнер) или продолжает работу (метроном) — настраивается через lifecycle

### T9.2 Батарея

- Тюнер: захват аудио прекращается при переходе приложения в фон
- Метроном: при фоновом режиме — уведомление с возможностью остановить (если требуется)

### T9.3 UI

- Gauge тюнера рендерится через `CustomPainter`, не через стандартные виджеты
- Все анимации — через `AnimationController` с `vsync`, не через `Future.delayed`
- Избегать `setState` в hot path аудиопотока — только через `StateNotifier`

---

## T10. Тестирование

### T10.1 Unit тесты

- [ ] `MusicUtils.frequencyToNote` — корректность для всех нот и октав
- [ ] `MusicUtils.tempoName` — корректность маппинга BPM → название
- [ ] `MetronomeState` — валидация диапазонов BPM, беатов
- [ ] `TunerNotifier` — переходы состояний

### T10.2 Widget тесты

- [ ] `GaugeWidget` — корректный рендер для cents = -50, 0, +50
- [ ] `BeatIndicators` — количество индикаторов соответствует `beatsPerBar`
- [ ] `ToolCard` — отображение badge «Скоро» для `isAvailable = false`

### T10.3 Integration тесты

- [ ] Навигация: главный экран → тюнер → назад → метроном
- [ ] Смена темы отражается на всех экранах
- [ ] Настройки сохраняются между запусками

---

## T11. Deliverables от разработки

### T11.1 MVP (v1.0)

- [ ] Настроенный Flutter проект с Material 3, Riverpod, go_router
- [ ] Дизайн-система в коде (цвета, типографика, компоненты) — токены из `docs/design.pen`
- [ ] Главный экран с Tool Registry
- [ ] Тюнер: захват аудио, pitch detection, gauge, настройка A4
- [ ] Метроном: точный timing, beat indicators, BPM slider, tap tempo
- [ ] Светлая и тёмная тема
- [ ] Локализация: ru + en, все строки в ARB-файлах, переключение в настройках
- [ ] Экран настроек с переключением темы и языка
- [ ] Сохранение последних настроек каждого инструмента
- [ ] Unit и widget тесты
- [ ] Соответствие требованиям App Store и Google Play (см. T14)
- [ ] Сборки для TestFlight (iOS) и Firebase App Distribution (Android)

### T11.2 Конфигурация проекта

```yaml
# pubspec.yaml (основные зависимости)
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  go_router: ^13.0.0
  shared_preferences: ^2.2.0
  permission_handler: ^11.0.0
  record: ^5.0.0          # аудиозахват
  flutter_soloud: ^2.0.0  # аудиовоспроизведение метронома

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
```

---

## T12. Расширение: добавление нового инструмента

Для добавления нового инструмента разработчику необходимо:

1. Создать директорию `lib/features/<tool_name>/`
2. Реализовать `ToolDefinition` в `<tool_name>_module.dart`
3. Создать экран и виджеты инструмента
4. Добавить маршрут в `router.dart`
5. Зарегистрировать в `main.dart`: `ToolRegistry.register(NewToolModule.definition)`

**Больше никаких изменений в существующем коде не требуется.**

---

## T13. Метаданные сборки

| Параметр | Значение |
|---|---|
| Bundle ID (iOS) | `com.tono.app` |
| Application ID (Android) | `com.tono.app` |
| Min iOS | 15.0 |
| Min Android SDK | 26 (Android 8.0) |
| Target Android SDK | 34 |
| Ориентация | Portrait only |
| Поддержка планшетов | Нет (v1.0) |

---

## T14. Соответствие требованиям App Store и Google Play

MVP должно быть готово к публикации в обоих магазинах без блокирующих замечаний от ревью. Ниже перечислены обязательные требования.

### T14.1 Общие требования

| Требование | Детали |
|---|---|
| Privacy Policy | Ссылка на политику конфиденциальности обязательна в обоих сторах и на экране «О приложении» |
| Разрешения | Запрашивать только необходимые разрешения (микрофон — только при открытии тюнера); описание назначения в `Info.plist` / `AndroidManifest.xml` |
| Возрастной рейтинг | 4+ (iOS) / Everyone (Android) |
| Поддержка актуальных SDK | Target SDK Android 34+; iOS deployment target 15.0+ |
| Иконка и скриншоты | Иконка 1024×1024px без альфа-канала (iOS); скриншоты для всех обязательных размеров экранов |
| Название и описание | Локализованы на ru и en в метаданных стора |

### T14.2 App Store (Apple)

- **Microphone usage description:** заполнен ключ `NSMicrophoneUsageDescription` в `Info.plist` — чёткое объяснение на языке пользователя
- **App Transport Security:** если используются сетевые запросы — только HTTPS; для MVP (offline-only) ATS не требует исключений
- **Background modes:** если метроном работает в фоне — указать `audio` в Background Modes и обосновать при ревью
- **No private API usage:** использование только публичных Flutter/iOS API
- **Data collection:** если не собираются данные пользователя — явно указать «No data collected» в App Privacy

### T14.3 Google Play

- **Target API level:** Android 14 (API 34) или актуальный required target на момент публикации
- **Permissions declaration:** в Play Console задекларировать использование `RECORD_AUDIO` с обоснованием
- **Data safety section:** заполнить раздел Data Safety (данные не собираются и не передаются третьим лицам)
- **Content rating:** пройти анкету IARC для получения рейтинга Everyone
- **App signing:** настроить Play App Signing (Google управляет ключом публикации)
- **64-bit support:** Flutter собирает arm64 по умолчанию — убедиться, что нативные плагины не содержат только 32-bit .so

### T14.4 Чеклист перед публикацией

- [ ] `applicationId` / `Bundle ID`: `com.tono.app` зарегистрирован в App Store Connect и Google Play Console
- [ ] Иконка приложения готова во всех требуемых размерах
- [ ] Скриншоты для iPhone 6.7" и 6.5", iPad Pro 12.9" (App Store); телефон и планшет 7" (Play)
- [ ] Краткое и полное описание переведены на ru и en
- [ ] Privacy Policy размещена по публичному URL
- [ ] `NSMicrophoneUsageDescription` заполнен на английском
- [ ] Data Safety (Play) / App Privacy (App Store) заполнены корректно
- [ ] Release build проверен на реальных устройствах iOS и Android
- [ ] Версия и build number корректно выставлены в `pubspec.yaml` и нативных конфигах

---

*Конец документа*
