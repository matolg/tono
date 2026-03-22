import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

/// Full-width primary action button (height 60, radius 14).
/// Matches the "Action Button" component from the design system.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 60,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.bodyL(color: Colors.white).copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}
