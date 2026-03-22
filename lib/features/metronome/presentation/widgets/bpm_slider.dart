import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/metronome_state.dart';

/// Slider (40–220 BPM) + ±1 buttons with long-press acceleration.
/// Shows Italian tempo name below the slider.
///
/// [onChanged] fires continuously while dragging (update display only).
/// [onChangeEnd] fires when drag or button press completes (update engine).
class BpmSlider extends StatefulWidget {
  final int bpm;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onChangeEnd;

  const BpmSlider({
    super.key,
    required this.bpm,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  State<BpmSlider> createState() => _BpmSliderState();
}

class _BpmSliderState extends State<BpmSlider> {
  Timer? _repeatTimer;

  void _startRepeat(int delta) {
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      final next =
          (widget.bpm + delta).clamp(MetronomeState.minBpm, MetronomeState.maxBpm);
      widget.onChanged(next);
    });
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    widget.onChangeEnd(widget.bpm);
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final surfaceVariant =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      children: [
        // ── Slider ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primary,
              inactiveTrackColor: surfaceVariant,
              thumbColor: primary,
              overlayColor: primary.withValues(alpha: 0.12),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: widget.bpm.toDouble(),
              min: MetronomeState.minBpm.toDouble(),
              max: MetronomeState.maxBpm.toDouble(),
              onChanged: (v) => widget.onChanged(v.round()),
              onChangeEnd: (v) => widget.onChangeEnd(v.round()),
            ),
          ),
        ),
        // ── Slider labels ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${MetronomeState.minBpm}',
                  style: AppTextStyles.label(color: textSecondary)),
              Text('${MetronomeState.maxBpm}',
                  style: AppTextStyles.label(color: textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // ── ± buttons + tempo name ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepButton(
                icon: Icons.remove,
                surface: surface,
                onTap: () {
                  final v = (widget.bpm - 1)
                      .clamp(MetronomeState.minBpm, MetronomeState.maxBpm);
                  widget.onChanged(v);
                  widget.onChangeEnd(v);
                },
                onLongPressStart: () => _startRepeat(-1),
                onLongPressEnd: _stopRepeat,
              ),
              Text(
                _tempoName(widget.bpm),
                style: AppTextStyles.bodyL(color: textPrimary).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              _StepButton(
                icon: Icons.add,
                surface: surface,
                onTap: () {
                  final v = (widget.bpm + 1)
                      .clamp(MetronomeState.minBpm, MetronomeState.maxBpm);
                  widget.onChanged(v);
                  widget.onChangeEnd(v);
                },
                onLongPressStart: () => _startRepeat(1),
                onLongPressEnd: _stopRepeat,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _tempoName(int bpm) {
    if (bpm < 60) return 'Largo';
    if (bpm < 66) return 'Larghetto';
    if (bpm < 76) return 'Adagio';
    if (bpm < 108) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 156) return 'Allegro';
    if (bpm < 176) return 'Vivace';
    if (bpm < 200) return 'Presto';
    return 'Prestissimo';
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Color surface;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  const _StepButton({
    required this.icon,
    required this.surface,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
