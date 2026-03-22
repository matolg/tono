import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class BpmDisplay extends StatelessWidget {
  final int bpm;

  const BpmDisplay({super.key, required this.bpm});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$bpm',
          style: AppTextStyles.display(color: textPrimary),
        ),
        Text(
          'BPM',
          style: AppTextStyles.bodySm(color: textSecondary).copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
