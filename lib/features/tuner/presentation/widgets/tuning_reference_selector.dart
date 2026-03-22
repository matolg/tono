import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Pill button showing "Строй: A = {value} Hz".
/// Tapping opens a ModalBottomSheet to pick a value from 432–444 Hz.
class TuningReferenceSelector extends StatelessWidget {
  final double referenceA4;
  final ValueChanged<double> onChanged;

  const TuningReferenceSelector({
    super.key,
    required this.referenceA4,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
    final textColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _showSheet(context, l10n),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${l10n.tunerReferenceA4}: A = ${referenceA4.toStringAsFixed(0)} Hz',
              style: AppTextStyles.label(color: textColor),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: textColor),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ReferenceSheet(
        current: referenceA4,
        onSelected: (v) {
          Navigator.of(context).pop();
          onChanged(v);
        },
        label: l10n.tunerReferenceA4,
      ),
    );
  }
}

class _ReferenceSheet extends StatelessWidget {
  final double current;
  final ValueChanged<double> onSelected;
  final String label;

  const _ReferenceSheet({
    required this.current,
    required this.onSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final values = List.generate(13, (i) => (432 + i).toDouble()); // 432–444

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.75,
      builder: (_, scrollController) => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: AppTextStyles.headlineM(color: textPrimary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: values.length,
                itemBuilder: (_, i) {
                  final v = values[i];
                  final isSelected = v == current;
                  return InkWell(
                    onTap: () => onSelected(v),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Text(
                            'A = ${v.toStringAsFixed(0)} Hz',
                            style: AppTextStyles.bodyL(
                              color: isSelected ? primary : textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(Icons.check, color: primary, size: 20),
                          if (!isSelected && v == 440)
                            Text(
                              'standard',
                              style: AppTextStyles.caption(color: textSecondary),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
