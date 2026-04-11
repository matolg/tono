import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/music_utils.dart';
import '../data/pitch_detector.dart';
import 'tuner_state.dart';

class TunerNotifier extends Notifier<TunerState> {
  PitchDetector? _detector;
  StreamSubscription<double?>? _sub;

  // ── Smoothing ────────────────────────────────────────────────────────────────
  /// EMA weight for incoming readings (0 = frozen, 1 = no smoothing).
  static const double _alpha = 0.3;

  /// Consecutive frames a new note must appear before being accepted.
  static const int _stabilityThreshold = 3;

  double? _smoothedCents;
  double? _smoothedFreq;

  // Currently displayed note
  String? _currentNote;
  int? _currentOctave;

  // Candidate note awaiting stability confirmation
  String? _pendingNote;
  int? _pendingOctave;
  int _pendingCount = 0;

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

    _resetSmoothing();
    state = state.copyWith(status: TunerStatus.listening, clearNote: true);

    _detector = PitchDetector();
    await _detector!.start();

    _sub = _detector!.frequencies.listen(_onFrequency);
  }

  void _onFrequency(double? freq) {
    if (freq == null) {
      _resetSmoothing();
      state = state.copyWith(status: TunerStatus.listening, clearNote: true);
      return;
    }

    final note = MusicUtils.frequencyToNote(freq, referenceA4: state.referenceA4);
    if (note == null) return;

    final isSameNote =
        note.noteName == _currentNote && note.octave == _currentOctave;

    if (isSameNote) {
      // Same note: smooth cents and frequency via EMA.
      _pendingNote = null;
      _pendingCount = 0;
      _smoothedCents = _smoothedCents == null
          ? note.cents
          : _alpha * note.cents + (1 - _alpha) * _smoothedCents!;
      _smoothedFreq = _smoothedFreq == null
          ? note.frequency
          : _alpha * note.frequency + (1 - _alpha) * _smoothedFreq!;
    } else {
      // Different note: require stability before accepting.
      if (note.noteName == _pendingNote && note.octave == _pendingOctave) {
        _pendingCount++;
      } else {
        _pendingNote = note.noteName;
        _pendingOctave = note.octave;
        _pendingCount = 1;
      }

      // Accept immediately when nothing is displayed yet, otherwise wait.
      final readyToSwitch =
          _currentNote == null || _pendingCount >= _stabilityThreshold;
      if (!readyToSwitch) return;

      _currentNote = _pendingNote;
      _currentOctave = _pendingOctave;
      _smoothedCents = note.cents;
      _smoothedFreq = note.frequency;
      _pendingNote = null;
      _pendingCount = 0;
    }

    state = TunerState(
      status: TunerStatus.detected,
      noteName: _currentNote,
      octave: _currentOctave,
      frequency: _smoothedFreq,
      cents: _smoothedCents,
      referenceA4: state.referenceA4,
    );
  }

  void _resetSmoothing() {
    _smoothedCents = null;
    _smoothedFreq = null;
    _currentNote = null;
    _currentOctave = null;
    _pendingNote = null;
    _pendingOctave = null;
    _pendingCount = 0;
  }

  Future<void> stopListening() async {
    await _disposeResources();
    _resetSmoothing();
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
