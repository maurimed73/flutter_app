import 'package:PadsBuga/models/music_class_server.dart';
import 'package:PadsBuga/provider/mid_provider.dart';
import 'package:flutter/material.dart';

import 'package:PadsBuga/screens/pads/pad_button.dart';
import 'package:provider/provider.dart';

class MusicPad extends StatefulWidget {
  final KitServer music;
  MusicPad({super.key, required this.music});

  @override
  State<MusicPad> createState() => _MusicPadState();
}

class _MusicPadState extends State<MusicPad> {
  // KitSample kitsample = KitSample(

  String getHeightButtonSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 600) {
      // Tablet
      return "tablet";
    }
    return 'phone';
  }

  String Status = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<MidiProvider>(
      builder: (context, midi, child) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      PadButton(
                        kitServer: widget.music,
                        numberPatch: 1,
                        audioPath: widget.music.sound1Patch,
                        baseColor: Color(0xff2d3e50),
                        nomePad: widget.music.sound1Nome,
                      ),
                      PadButton(
                        kitServer: widget.music,
                        numberPatch: 2,
                        audioPath: widget.music.sound2Patch,
                        baseColor: Color(0xff2d3e50),
                        nomePad: widget.music.sound2Nome,
                      ),
                      PadButton(
                        kitServer: widget.music,
                        numberPatch: 3,
                        audioPath: widget.music.sound3Patch,
                        baseColor: Color(0xff2d3e50),
                        nomePad: widget.music.sound3Nome,
                      ),
                      PadButton(
                        kitServer: widget.music,
                        numberPatch: 4,
                        audioPath: widget.music.sound4Patch,
                        baseColor: Color(0xff2d3e50),
                        nomePad: widget.music.sound4Nome,
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 20),
                Text(midi.status),
                ElevatedButton(
                  onPressed: () {
                    midi.simulateNote(36);
                  },
                  child: Text("Testar Nota 36"),
                ),
                ElevatedButton(
                  onPressed: () {
                    midi.simulateNote(37);
                  },
                  child: Text("Testar Nota 37"),
                ),
                GestureDetector(
                  onTap: AudioManager.stopAll,
                  child: Container(
                    width: double.infinity,
                    height: getHeightButtonSize(context) == 'tablet' ? 80 : 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white24,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'STOP ALL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: getHeightButtonSize(context) == 'tablet' ? 80 : 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white24,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'MENU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
