import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/tuner_notifier.dart';
import '../domain/tuner_state.dart';
import 'widgets/gauge_widget.dart';
import 'widgets/note_display.dart';
import 'widgets/octave_dots.dart';
import 'widgets/tuning_reference_selector.dart';

class TunerScreen extends ConsumerStatefulWidget {
  const TunerScreen({super.key});

  @override
  ConsumerState<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends ConsumerState<TunerScreen> {
  bool _wasInTune = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(tunerProvider);
    final notifier = ref.read(tunerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Haptic feedback when entering/leaving in-tune zone (|cents| <= 5)
    final inTune =
        state.status == TunerStatus.detected &&
        state.cents != null &&
        state.cents!.abs() <= 5;
    if (inTune && !_wasInTune) {
      HapticFeedback.lightImpact();
    }
    _wasInTune = inTune;

    final isListening = state.status == TunerStatus.listening ||
        state.status == TunerStatus.detected;

    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      appBar: AppBarWidget(title: l10n.screenTunerTitle, showBack: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // ── Note display ──────────────────────────────────────────────
              NoteDisplay(
                noteName: state.noteName,
                octave: state.octave,
                frequency: state.frequency,
              ),

              const SizedBox(height: 24),

              // ── Gauge ─────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 340 / 177,
                  child: GaugeWidget(
                    cents: state.status == TunerStatus.detected
                        ? state.cents
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Octave dots ───────────────────────────────────────────────
              OctaveDots(
                octave: state.status == TunerStatus.detected
                    ? state.octave
                    : null,
              ),

              const SizedBox(height: 8),

              // ── Status label ──────────────────────────────────────────────
              Text(
                _statusLabel(state, l10n),
                style: AppTextStyles.bodyM(color: textSecondary),
              ),

              const Spacer(),

              // ── Reference selector ────────────────────────────────────────
              TuningReferenceSelector(
                referenceA4: state.referenceA4,
                onChanged: notifier.setReferenceA4,
              ),

              const SizedBox(height: 16),

              // ── Error message ─────────────────────────────────────────────
              if (state.status == TunerStatus.error)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.errorMicrophonePermissionDenied,
                    style: AppTextStyles.bodyM(
                      color: isDark ? AppColors.errorDark : AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // ── Start / Stop button ───────────────────────────────────────
              PrimaryButton(
                label: isListening
                    ? l10n.tunerStopListening
                    : l10n.tunerStartListening,
                icon: isListening ? Icons.stop : Icons.mic,
                onPressed: isListening
                    ? notifier.stopListening
                    : notifier.startListening,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(TunerState state, AppLocalizations l10n) {
    return switch (state.status) {
      TunerStatus.idle => '',
      TunerStatus.listening => l10n.tunerListening,
      TunerStatus.detected => '',
      TunerStatus.error => '',
    };
  }
}
