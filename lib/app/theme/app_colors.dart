import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Light ──────────────────────────────────────────────────────────────────
  static const background = Color(0xFFF5F4F1);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEDECEA);
  static const divider = Color(0xFFE5E4E1);

  static const primary = Color(0xFFC4856A);
  static const primaryContainer = Color(0xFFF5E0D8);

  static const textPrimary = Color(0xFF1A1918);
  static const textSecondary = Color(0xFF6D6C6A);
  static const textTertiary = Color(0xFFFFFFFF);

  static const error = Color(0xFFD08068);

  static const gaugeOff = Color(0xFFF5BDB5);
  static const gaugeClose = Color(0xFFEEE5A0);
  static const gaugeInTune = Color(0xFFB8E8C4);

  // ── Dark ───────────────────────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF1C1A18);
  static const surfaceDark = Color(0xFF252320);
  static const surfaceVariantDark = Color(0xFF2E2B28);
  static const dividerDark = Color(0xFF2E2B28);

  static const primaryDark = Color(0xFFD4957A);
  static const primaryContainerDark = Color(0xFF3D2A24);

  static const textPrimaryDark = Color(0xFFF0EDE8);
  static const textSecondaryDark = Color(0xFF8A8380);
  static const textTertiaryDark = Color(0xFFFFFFFF);

  static const errorDark = Color(0xFFE09078);

  static const gaugeOffDark = Color(0xFF904040);
  static const gaugeCloseDark = Color(0xFF8A8030);
  static const gaugeInTuneDark = Color(0xFF4A9860);

  // ── Opacity ────────────────────────────────────────────────────────────────
  static const double opacityDisabled = 0.45;
  static const double opacityOverlay = 0.08;
  static const double opacityPressed = 0.88;
}
