import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  // ── Primary font (Inter) ───────────────────────────────────────────────────

  static TextStyle headlineL({Color? color}) => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle headlineM({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle bodyL({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle bodyM({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle bodySm({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle display({Color? color}) => GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w300,
        letterSpacing: -2,
        color: color,
      );

  // ── Mono font (JetBrains Mono) ─────────────────────────────────────────────

  static TextStyle monoDisplay({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 52,
        fontWeight: FontWeight.w400,
        letterSpacing: -1,
        color: color,
      );

  static TextStyle monoLabel({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color,
      );
}
