import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

const _options = [
  (beats: 2, unit: 4, label: '2/4'),
  (beats: 3, unit: 4, label: '3/4'),
  (beats: 4, unit: 4, label: '4/4'),
  (beats: 5, unit: 4, label: '5/4'),
  (beats: 6, unit: 8, label: '6/8'),
];

class TimeSignatureSelector extends StatelessWidget {
  final int beatsPerBar;
  final int beatUnit;
  final void Function(int beats, int unit) onChanged;

  const TimeSignatureSelector({
    super.key,
    required this.beatsPerBar,
    required this.beatUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final bg = isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
    final selectedText = AppColors.textTertiary;
    final unselectedText =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _options.map((opt) {
          final isSelected =
              opt.beats == beatsPerBar && opt.unit == beatUnit;
          return GestureDetector(
            onTap: () => onChanged(opt.beats, opt.unit),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52,
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                opt.label,
                style: AppTextStyles.label(
                  color: isSelected ? selectedText : unselectedText,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
