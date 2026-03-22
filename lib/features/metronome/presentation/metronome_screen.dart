import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/metronome_notifier.dart';
import '../domain/metronome_state.dart';
import 'widgets/beat_indicators.dart';
import 'widgets/bpm_display.dart';
import 'widgets/bpm_slider.dart';
import 'widgets/time_signature_selector.dart';

class MetronomeScreen extends ConsumerStatefulWidget {
  const MetronomeScreen({super.key});

  @override
  ConsumerState<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends ConsumerState<MetronomeScreen> {
  // Tap-tempo: keep timestamps of last 5 taps
  final List<DateTime> _tapTimes = [];
  bool _engineReady = false;
  late MetronomeNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(metronomeProvider.notifier);
    _initEngine();
  }

  @override
  void dispose() {
    _notifier.stop();
    super.dispose();
  }

  Future<void> _initEngine() async {
    await _notifier.init();
    if (mounted) setState(() => _engineReady = true);
  }

  void _onTapTempo() {
    final now = DateTime.now();
    _tapTimes.add(now);
    if (_tapTimes.length > 5) _tapTimes.removeAt(0);
    if (_tapTimes.length >= 2) {
      double totalMs = 0;
      for (int i = 1; i < _tapTimes.length; i++) {
        totalMs += _tapTimes[i].difference(_tapTimes[i - 1]).inMilliseconds;
      }
      final avgMs = totalMs / (_tapTimes.length - 1);
      final bpm = (60000 / avgMs)
          .round()
          .clamp(MetronomeState.minBpm, MetronomeState.maxBpm);
      ref.read(metronomeProvider.notifier).applyBpm(bpm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(metronomeProvider);
    final notifier = ref.read(metronomeProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _notifier.stop();
      },
      child: Scaffold(
      appBar: AppBarWidget(title: l10n.screenMetronomeTitle, showBack: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Beat indicators (tap = tap tempo) ─────────────────────────────
            BeatIndicators(
              beatsPerBar: state.beatsPerBar,
              currentBeat: state.currentBeat,
              isPlaying: state.isPlaying,
              onTap: _onTapTempo,
            ),

            // ── BPM number ────────────────────────────────────────────────────
            BpmDisplay(bpm: state.bpm),

            const SizedBox(height: 8),

            // ── Slider + ±1 buttons ───────────────────────────────────────────
            BpmSlider(
              bpm: state.bpm,
              onChanged: notifier.setBpm,
              onChangeEnd: notifier.applyBpm,
            ),

            const SizedBox(height: 20),

            // ── Time signature selector ───────────────────────────────────────
            TimeSignatureSelector(
              beatsPerBar: state.beatsPerBar,
              beatUnit: state.beatUnit,
              onChanged: (beats, unit) {
                notifier.setBeatsPerBar(beats);
                notifier.setBeatUnit(unit);
              },
            ),

            const Spacer(),

            // ── Start / Stop button ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                label: state.isPlaying
                    ? l10n.metronomeStop
                    : l10n.metronomeStart,
                icon: state.isPlaying ? Icons.stop : Icons.play_arrow,
                onPressed: _engineReady
                    ? (state.isPlaying ? notifier.stop : () => notifier.start())
                    : null,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ), // Scaffold
    ); // PopScope
  }
}
