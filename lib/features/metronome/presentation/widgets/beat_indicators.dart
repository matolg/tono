import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Row of beat squares. Active beat is larger and uses primary colour.
/// Supports tap-tempo via [onTap].
class BeatIndicators extends StatelessWidget {
  final int beatsPerBar;
  final int currentBeat; // 0-indexed; -1 = none active
  final bool isPlaying;
  final VoidCallback? onTap;

  const BeatIndicators({
    super.key,
    required this.beatsPerBar,
    required this.currentBeat,
    required this.isPlaying,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final inactive =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(beatsPerBar, (i) {
            final isActive = isPlaying && i == currentBeat;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: isActive ? 56 : 48,
              height: isActive ? 56 : 48,
              decoration: BoxDecoration(
                color: isActive ? primary : inactive,
                borderRadius: BorderRadius.circular(isActive ? 12 : 8),
              ),
            );
          }),
        ),
      ),
    );
  }
}
