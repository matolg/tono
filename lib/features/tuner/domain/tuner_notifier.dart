import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/music_utils.dart';
import '../data/pitch_detector.dart';
import 'tuner_state.dart';

class TunerNotifier extends Notifier<TunerState> {
  PitchDetector? _detector;
  StreamSubscription<double?>? _sub;

  @override
  TunerState build() {
    ref.onDispose(_disposeResources);
    return const TunerState();
  }

  Future<void> startListening() async {
    final granted = await PermissionService.requestMicrophone();
    if (!granted) {
      state = state.copyWith(status: TunerStatus.error);
      return;
    }

    state = state.copyWith(status: TunerStatus.listening, clearNote: true);

    _detector = PitchDetector();
    await _detector!.start();

    _sub = _detector!.frequencies.listen((freq) {
      if (freq == null) {
        state = state.copyWith(
          status: TunerStatus.listening,
          clearNote: true,
        );
        return;
      }

      final note = MusicUtils.frequencyToNote(
        freq,
        referenceA4: state.referenceA4,
      );
      if (note != null) {
        state = TunerState(
          status: TunerStatus.detected,
          noteName: note.noteName,
          octave: note.octave,
          frequency: note.frequency,
          cents: note.cents,
          referenceA4: state.referenceA4,
        );
      }
    });
  }

  Future<void> stopListening() async {
    await _disposeResources();
    state = TunerState(referenceA4: state.referenceA4);
  }

  void setReferenceA4(double value) {
    state = state.copyWith(referenceA4: value);
  }

  Future<void> _disposeResources() async {
    await _sub?.cancel();
    _sub = null;
    await _detector?.dispose();
    _detector = null;
  }
}

final tunerProvider =
    NotifierProvider<TunerNotifier, TunerState>(TunerNotifier.new);
