import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Five dots representing octaves C2–C6.
/// The active octave dot is larger and uses the primary colour.
class OctaveDots extends StatefulWidget {
  /// Current octave (2–6). Null when no pitch is detected.
  final int? octave;

  const OctaveDots({super.key, required this.octave});

  @override
  State<OctaveDots> createState() => _OctaveDotsState();
}

class _OctaveDotsState extends State<OctaveDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? _prev;
  int? _curr;

  static const _minOctave = 2;
  static const _maxOctave = 6;
  static const _dotCount = _maxOctave - _minOctave + 1; // 5

  @override
  void initState() {
    super.initState();
    _curr = widget.octave;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(OctaveDots old) {
    super.didUpdateWidget(old);
    if (widget.octave != old.octave) {
      _prev = old.octave;
      _curr = widget.octave;
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
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final inactive =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_dotCount * 2 - 1, (i) {
            if (i.isOdd) {
              return const SizedBox(width: 12);
            }
            final octave = _minOctave + i ~/ 2;
            final isActive = octave == _curr;
            final wasActive = octave == _prev;

            double size;
            Color color;
            if (isActive) {
              size = lerpDouble(10, 14, t)!;
              color = Color.lerp(inactive, primary, t)!;
            } else if (wasActive) {
              size = lerpDouble(14, 10, t)!;
              color = Color.lerp(primary, inactive, t)!;
            } else {
              size = 10;
              color = inactive;
            }

            return SizedBox(
              width: 14,
              height: 14,
              child: Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
