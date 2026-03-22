import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/providers/locale_notifier.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bar_widget.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    (code: 'ru', label: 'Русский'),
    (code: 'en', label: 'English'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentCode = ref.watch(localeProvider).languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(title: l10n.settingsLanguageTitle, showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _languages.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 16,
                      color: isDark ? AppColors.dividerDark : AppColors.divider,
                    ),
                  _LanguageRow(
                    label: _languages[i].label,
                    selected: currentCode == _languages[i].code,
                    isDark: isDark,
                    onTap: () => ref
                        .read(localeProvider.notifier)
                        .setLocale(Locale(_languages[i].code)),
                    colorScheme: colorScheme,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyL(color: colorScheme.onSurface),
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: 20,
                color: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
