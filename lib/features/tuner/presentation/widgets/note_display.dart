import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Displays the detected note name, octave number, and frequency in Hz.
/// Shows a placeholder when no pitch is detected.
class NoteDisplay extends StatelessWidget {
  final String? noteName;
  final int? octave;
  final double? frequency;

  const NoteDisplay({
    super.key,
    required this.noteName,
    required this.octave,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final secondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final tertiary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final hasNote = noteName != null && octave != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Note name + octave
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasNote ? noteName! : '—',
              style: AppTextStyles.monoDisplay(color: hasNote ? primary : secondary),
            ),
            if (hasNote)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${octave!}',
                  style: AppTextStyles.monoLabel(color: secondary),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        // Frequency in Hz
        Text(
          frequency != null
              ? '${frequency!.toStringAsFixed(1)} Hz'
              : '',
          style: AppTextStyles.bodyM(color: tertiary),
        ),
      ],
    );
  }
}
