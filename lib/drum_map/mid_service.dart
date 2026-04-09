import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiService {
  final MidiCommand _midi = MidiCommand();

  Function(int note, int velocity)? onMidi;
  Function(String status)? onStatus;

  Future<void> init() async {
    final devices = await _midi.devices;

    if (devices == null || devices.isEmpty) {
      onStatus?.call("Nenhum dispositivo MIDI");
      return;
    }

    final device = devices.firstWhere(
      (d) => d.name.contains("TD-9"),
      orElse: () => devices.first,
    );

    onStatus?.call("Conectando em ${device.name}...");

    await _midi.connectToDevice(device);

    onStatus?.call("Conectado em ${device.name}");

    _midi.onMidiDataReceived?.listen((event) {
      final data = event.data;

      if (data.length >= 3 && (data[0] & 0xF0) == 0x90) {
        int note = data[1];
        int velocity = data[2];

        if (velocity > 0) {
          onMidi?.call(note, velocity);
        }
      }
    });
  }
}
