import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Horizontal bar gauge showing cents deviation (–50..+50).
/// Matches the Gauge Frame component from the design (340×177).
class GaugeWidget extends StatefulWidget {
  /// Current cents deviation. Null when no pitch is detected.
  final double? cents;

  const GaugeWidget({super.key, required this.cents});

  @override
  State<GaugeWidget> createState() => _GaugeWidgetState();
}

class _GaugeWidgetState extends State<GaugeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  double _from = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80), // animation/micro
      vsync: this,
    );
    _anim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(GaugeWidget old) {
    super.didUpdateWidget(old);
    final target = widget.cents ?? 0;
    final prev = old.cents ?? 0;
    if (target != prev) {
      _from = _anim.value;
      _anim = Tween<double>(begin: _from, end: target).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        size: const Size(340, 177),
        painter: GaugePainter(
          cents: _anim.value,
          showNeedle: widget.cents != null,
          isDark: isDark,
        ),
      ),
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────

class GaugePainter extends CustomPainter {
  final double cents;
  final bool showNeedle;
  final bool isDark;

  const GaugePainter({
    required this.cents,
    required this.showNeedle,
    required this.isDark,
  });

  // Design constants (in 340×177 space)
  static const _barY = 72.0;
  static const _barH = 10.0;
  static const _barXStart = 20.0;
  static const _barXEnd = 320.0;
  static const _barW = _barXEnd - _barXStart; // 300

  static const _closeXStart = 75.0;
  static const _closeW = 190.0;
  static const _tuneXStart = 130.0;
  static const _tuneW = 80.0;

  static const _centerTickX = 169.0;
  static const _tickY = 58.0;
  static const _tickH = 36.0;

  static const _needleH = 46.0;
  static const _needleW = 3.0;
  static const _needleTopY = 52.0;
  static const _needleCircleR = 4.5;

  static const _labelY = 95.0;
  static const _labelSize = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale factors to support different canvas sizes
    final sx = size.width / 340;
    final sy = size.height / 177;

    Rect scaled(double x, double y, double w, double h) =>
        Rect.fromLTWH(x * sx, y * sy, w * sx, h * sy);

    // ── 1. Coloured bars ──────────────────────────────────────────────────────
    final paintOff = Paint()
      ..color =
          isDark ? AppColors.gaugeOffDark : AppColors.gaugeOff;
    final paintClose = Paint()
      ..color =
          isDark ? AppColors.gaugeCloseDark : AppColors.gaugeClose;
    final paintTune = Paint()
      ..color =
          isDark ? AppColors.gaugeInTuneDark : AppColors.gaugeInTune;

    final barRadius = Radius.circular(5 * sx);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          scaled(_barXStart, _barY, _barW, _barH), barRadius),
      paintOff,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          scaled(_closeXStart, _barY, _closeW, _barH), barRadius),
      paintClose,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          scaled(_tuneXStart, _barY, _tuneW, _barH), barRadius),
      paintTune,
    );

    // ── 2. Center tick ────────────────────────────────────────────────────────
    final tickPaint = Paint()
      ..color = const Color(0xFF8FC99A)
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scaled(_centerTickX, _tickY, 2, _tickH),
        const Radius.circular(1),
      ),
      tickPaint,
    );

    // ── 3. Labels ─────────────────────────────────────────────────────────────
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    void drawLabel(String text, double x, TextAlign align) {
      final span = TextSpan(
        text: text,
        style: AppTextStyles.caption(color: secondaryColor).copyWith(
          fontSize: _labelSize * sx,
          fontWeight: text == '0' ? FontWeight.w600 : FontWeight.w500,
        ),
      );
      final tp = TextPainter(
        text: span,
        textAlign: align,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 30 * sx);
      double dx = x * sx;
      if (align == TextAlign.center) dx -= tp.width / 2;
      if (align == TextAlign.right) dx -= tp.width;
      tp.paint(canvas, Offset(dx, _labelY * sy));
    }

    drawLabel('-50', _barXStart, TextAlign.left);
    drawLabel('0', (_barXStart + _barXEnd) / 2, TextAlign.center);
    drawLabel('+50', _barXEnd, TextAlign.right);

    // ── 4. Needle ─────────────────────────────────────────────────────────────
    if (!showNeedle) return;

    final needleX = _barXStart + (cents + 50) * _barW / 100;
    final needleColor =
        isDark ? AppColors.primaryDark : AppColors.primary;
    final needlePaint = Paint()..color = needleColor;

    // Needle body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scaled(needleX - _needleW / 2, _needleTopY, _needleW, _needleH),
        const Radius.circular(2),
      ),
      needlePaint,
    );
    // Needle top circle
    canvas.drawCircle(
      Offset(needleX * sx, (_needleTopY + _needleCircleR) * sy),
      _needleCircleR * ((sx + sy) / 2),
      needlePaint,
    );
  }

  @override
  bool shouldRepaint(GaugePainter old) =>
      old.cents != cents ||
      old.showNeedle != showNeedle ||
      old.isDark != isDark;
}
