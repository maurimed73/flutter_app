import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiProvider with ChangeNotifier {
  final MidiCommand _midi = MidiCommand();
  Function(int note)? onNote;
  Function(int note, int velocity)? onMidi;
  String status = "Inicializando...";
  bool _initialized = false;

  final _noteController = StreamController<int>.broadcast();

  Stream<int> get noteStream => _noteController.stream;

  void simulateNote(int note) {
    _noteController.add(note);
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final devices = await _midi.devices;

    if (devices == null || devices.isEmpty) {
      status = "Nenhum dispositivo MIDI encontrado";
      notifyListeners();
      return;
    }

    final device = devices.firstWhere(
      (d) => d.name.contains("TD-9"),
      orElse: () => devices.first,
    );

    await _midi.connectToDevice(device);

    status = "Conectado em ${device.name}";
    notifyListeners();

    _midi.onMidiDataReceived?.listen((event) {
      final data = event.data;

      if (data.length >= 3 && (data[0] & 0xF0) == 0x90) {
        int note = data[1];
        int velocity = data[2];

        // 🔥 COLOCA AQUI
        if (velocity > 0) {
          _noteController.add(note);
        }
      }
    });
  }
}
