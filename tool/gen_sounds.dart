import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void makeWav(String path, double freq,
    {double duration = 0.025, int sampleRate = 44100}) {
  final n = (sampleRate * duration).round();
  final samples = Int16List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    // Fast attack (5ms ramp-up) then exponential decay — gives a sharp click
    // with no discontinuity at start or end.
    final attack = (t < 0.005) ? t / 0.005 : 1.0;
    final decay = exp(-t * 180);
    samples[i] = (32767 * 0.85 * sin(2 * pi * freq * t) * attack * decay)
        .round()
        .clamp(-32768, 32767);
  }

  final data = samples.buffer.asUint8List();
  final ds = data.length;

  final buf = BytesBuilder();
  void u32(int v) => buf.add(Uint8List(4)..buffer.asByteData().setUint32(0, v, Endian.little));
  void u16(int v) => buf.add(Uint8List(2)..buffer.asByteData().setUint16(0, v, Endian.little));

  buf.add('RIFF'.codeUnits);
  u32(36 + ds);
  buf.add('WAVE'.codeUnits);
  buf.add('fmt '.codeUnits);
  u32(16);
  u16(1); // PCM
  u16(1); // mono
  u32(sampleRate);
  u32(sampleRate * 2); // byte rate
  u16(2); // block align
  u16(16); // bits per sample
  buf.add('data'.codeUnits);
  u32(ds);
  buf.add(data);

  File(path).writeAsBytesSync(buf.toBytes());
  print('Written: $path');
}

void main() {
  Directory('assets/sounds').createSync(recursive: true);
  makeWav('assets/sounds/metronome_accent.wav', 1200);
  makeWav('assets/sounds/metronome_tick.wav', 700);
}
