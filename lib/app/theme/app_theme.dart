import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.primaryDark : AppColors.primary,
      onPrimary: AppColors.textTertiary,
      primaryContainer:
          isDark ? AppColors.primaryContainerDark : AppColors.primaryContainer,
      onPrimaryContainer:
          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      secondary: isDark ? AppColors.primaryDark : AppColors.primary,
      onSecondary: AppColors.textTertiary,
      secondaryContainer:
          isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
      onSecondaryContainer:
          isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      surface: isDark ? AppColors.surfaceDark : AppColors.surface,
      onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      surfaceContainerHighest:
          isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
      onSurfaceVariant:
          isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      error: isDark ? AppColors.errorDark : AppColors.error,
      onError: AppColors.textTertiary,
      errorContainer: isDark
          ? AppColors.errorDark.withValues(alpha: 0.2)
          : AppColors.error.withValues(alpha: 0.1),
      onErrorContainer: isDark ? AppColors.errorDark : AppColors.error,
      outline: isDark ? AppColors.dividerDark : AppColors.divider,
      outlineVariant: isDark ? AppColors.dividerDark : AppColors.divider,
      scrim: Colors.black,
      inverseSurface:
          isDark ? AppColors.surface : AppColors.surfaceDark,
      onInverseSurface:
          isDark ? AppColors.textPrimary : AppColors.textPrimaryDark,
      inversePrimary: isDark ? AppColors.primary : AppColors.primaryDark,
    );

    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      displayColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
      textTheme: baseTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineM(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dividerDark : AppColors.divider,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.bodyL(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
