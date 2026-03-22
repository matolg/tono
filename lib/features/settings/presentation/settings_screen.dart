import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/providers/locale_notifier.dart';
import '../../../core/providers/theme_mode_notifier.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../shared/widgets/segment_control.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final currentLangLabel =
        currentLocale.languageCode == 'ru' ? 'Русский' : 'English';

    final themeModes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    String themeModeLabel(ThemeMode m) => switch (m) {
          ThemeMode.light => l10n.settingsThemeLight,
          ThemeMode.dark => l10n.settingsThemeDark,
          ThemeMode.system => l10n.settingsThemeSystem,
        };

    return Scaffold(
      appBar: AppBarWidget(title: l10n.screenSettingsTitle, showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // Appearance section
          _Section(
            header: l10n.settingsAppearanceSectionHeader,
            colorScheme: colorScheme,
            children: [
              _ThemeRow(
                label: l10n.settingsThemeTitle,
                themeModes: themeModes,
                selected: themeMode,
                labelOf: themeModeLabel,
                onChanged: (m) =>
                    ref.read(themeModeProvider.notifier).setThemeMode(m),
                colorScheme: colorScheme,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Language section
          _Section(
            header: l10n.settingsLanguageTitle,
            colorScheme: colorScheme,
            children: [
              _NavigationRow(
                label: l10n.settingsLanguageTitle,
                value: currentLangLabel,
                onTap: () => context.push('/settings/language'),
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Section container ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String header;
  final List<Widget> children;
  final ColorScheme colorScheme;

  const _Section({
    required this.header,
    required this.children,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              header,
              style: AppTextStyles.bodySm(color: colorScheme.onSurfaceVariant)
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ── Theme row with SegmentControl ─────────────────────────────────────────────

class _ThemeRow extends StatelessWidget {
  final String label;
  final List<ThemeMode> themeModes;
  final ThemeMode selected;
  final String Function(ThemeMode) labelOf;
  final ValueChanged<ThemeMode> onChanged;
  final ColorScheme colorScheme;

  const _ThemeRow({
    required this.label,
    required this.themeModes,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyL(color: colorScheme.onSurface)
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SegmentControl<ThemeMode>(
            values: themeModes,
            selected: selected,
            labelOf: labelOf,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── Navigation row ────────────────────────────────────────────────────────────

class _NavigationRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _NavigationRow({
    required this.label,
    required this.value,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyL(color: colorScheme.onSurface),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: AppTextStyles.bodyM(
                        color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '›',
                    style: AppTextStyles.bodyL(
                        color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
