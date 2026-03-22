import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/providers/locale_notifier.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bar_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentLangLabel =
        currentLocale.languageCode == 'ru' ? 'Русский' : 'English';

    return Scaffold(
      appBar: AppBarWidget(title: l10n.screenSettingsTitle, showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // Language section
          _Section(
            header: l10n.settingsLanguageTitle,
            colorScheme: colorScheme,
            isDark: isDark,
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

// ── Shared section container ──────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String header;
  final List<Widget> children;
  final ColorScheme colorScheme;
  final bool isDark;

  const _Section({
    required this.header,
    required this.children,
    required this.colorScheme,
    required this.isDark,
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
          // Section header inside card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              header,
              style: AppTextStyles.bodySm(
                color: colorScheme.onSurfaceVariant,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ── Row that navigates to a sub-screen ───────────────────────────────────────

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
