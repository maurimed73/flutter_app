import 'dart:async';
import 'dart:io';
import 'package:PadsBuga/database/kit_database_model.dart';
import 'package:PadsBuga/models/music_class_server.dart';
import 'package:PadsBuga/provider/mid_provider.dart';
import 'package:PadsBuga/provider/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';

class PadButton extends StatefulWidget {
  final String audioPath;
  final Color baseColor;
  final String nomePad;
  final int numberPatch;
  final KitServer kitServer; // 🔥 Identificador único

  const PadButton({
    super.key,
    required this.audioPath,
    required this.baseColor,
    required this.nomePad,
    required this.numberPatch,
    required this.kitServer,
  });

  @override
  State<PadButton> createState() => _PadButtonState();
}

class _PadButtonState extends State<PadButton> {
  late final AudioPlayer _player;
  late StreamSubscription midiSub;
  bool _isPlaying = false;
  bool _isLooping = false; // 🔥 Controle de Loop
  bool _isFading = false;

  late Color _buttonColor;
  double _volume = 0.0;
  String campo = '';
  String campoIsLoop = '';
  late MidiProvider midi;
  DateTime? lastHit;
  int noteNumber1 = 124;
  int noteNumber2 = 125;
  int noteNumber3 = 126;
  int noteNumber4 = 127;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    AudioManager.register(this);
    _buttonColor = widget.baseColor;

    _loadVolume();
    _prepareAudio();

    Future.delayed(Duration(seconds: 3), () {
      midi.noteStream.listen((note) {});
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && !_isLooping) {
        _handleAudioComplete();
      }
    });

    midi = Provider.of<MidiProvider>(context, listen: false);

    midi.init();

    midiSub = midi.noteStream.listen((note) {
      print("Pad ${widget.nomePad} recebeu nota $note");
      int? pad;

      switch (note) {
        case 124:
          pad = 3;
          break;

        case 125:
          pad = 4;
          break;
      }

      print("Nota $note virou pad $pad");
      if (pad == widget.numberPatch) {
        print("🔥 DISPAROU ${widget.nomePad}");
        _togglePlay();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();

    midiSub.cancel();
    AudioManager.unregister(this);
    super.dispose();
  }

  double getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 600) {
      // Tablet
      return 100;
    } else {
      // Smartphone
      return 100;
    }
  }

  String getHeightButtonSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 600) {
      // Tablet
      return "tablet";
    }
    return 'phone';
  }

  void _handleAudioComplete() {
    setState(() {
      _isPlaying = false;
      _buttonColor = widget.baseColor;
    });
    _player.stop();
  }

  Future<void> _loadVolume() async {
    switch (widget.numberPatch) {
      case 1:
        _volume = widget.kitServer.sound1Volume;
        campo = 'sound1Volume';
        campoIsLoop = 'isLoop1';
        _isLooping = widget.kitServer.isLoop1 == 1 ? true : false;
        break;
      case 2:
        _volume = widget.kitServer.sound2Volume;
        campo = 'sound2Volume';
        campoIsLoop = 'isLoop2';
        _isLooping = widget.kitServer.isLoop2 == 1 ? true : false;
        break;
      case 3:
        _volume = widget.kitServer.sound3Volume;
        campo = 'sound3Volume';
        campoIsLoop = 'isLoop3';
        _isLooping = widget.kitServer.isLoop3 == 1 ? true : false;
        break;
      case 4:
        _volume = widget.kitServer.sound4Volume;
        campo = 'sound4Volume';
        campoIsLoop = 'isLoop4';
        _isLooping = widget.kitServer.isLoop4 == 1 ? true : false;
        break;
    }
    setState(() {});
  }

  Future<void> _prepareAudio() async {
    final file = File(widget.audioPath);
    if (await file.exists()) {
      await _player.setFilePath(widget.audioPath);
      _player.setLoopMode(LoopMode.off);
      _player.setVolume(_volume);
    } else {
      print('❌ Arquivo não encontrado em ${widget.audioPath}');
    }
  }

  Future<void> _togglePlay() async {
    if (_isFading) return;

    if (!_isPlaying) {
      setState(() {
        _isPlaying = true;
        _buttonColor = const Color.fromARGB(255, 52, 118, 188);
      });

      _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);

      await _player.setVolume(0.0);
      await _player.seek(Duration.zero);
      _player.play();

      for (var v = 0.0; v <= _volume; v += 0.02) {
        await _player.setVolume(v);
        await Future.delayed(const Duration(milliseconds: 20));
      }
    } else {
      await _fadeOutWithColor();
    }
  }

  Future<void> _fadeOutWithColor() async {
    if (_isFading) return;
    _isFading = true;
    _isPlaying = false;

    const steps = 110;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final volume = (_volume * (1.0 - t)).clamp(0.0, 1.0);
      await _player.setVolume(volume);

      setState(() {
        _buttonColor = Color.lerp(const Color.fromARGB(255, 52, 118, 188), widget.baseColor, t)!;
      });

      await Future.delayed(const Duration(milliseconds: 10));
    }

    await _player.stop();
    await _player.setVolume(_volume);

    _isFading = false;
    setState(() {
      _buttonColor = widget.baseColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, provider, child) => Container(
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: getHeightButtonSize(context) == 'tablet' ? 20 : 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.36,
                        color: Colors.transparent,
                        child: Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          color: const Color.fromARGB(255, 237, 183, 20),
                          size: getIconSize(context),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: getHeightButtonSize(context) == 'tablet' ? 20 : 15,
                    ),

                    // 🔊 Slider de volume
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: getHeightButtonSize(context) == 'tablet' ? 30 : 15,
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: _volume,
                        onChanged: (value) async {
                          setState(() {
                            _volume = value;
                          });
                          _player.setVolume(_volume);
                          await KitDatabaseMobile.instance.updateMusicParam(title: widget.kitServer.title, campo: campo, valor: _volume);
                          provider.carregarMusicas();
                        },
                      ),
                    ),

                    Text(
                      widget.nomePad,
                      style: TextStyle(color: Colors.amber, fontSize: getHeightButtonSize(context) == 'tablet' ? 20 : 14),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLooping ? Icons.loop : Icons.loop_outlined,
                        color: _isLooping ? Colors.amber : Colors.white70,
                        size: getIconSize(context) * 0.2, // opcional ajustar tamanho
                      ),
                      onPressed: () {
                        setState(() {
                          _isLooping = !_isLooping;

                          KitDatabaseMobile.instance.updateMusicParam(title: widget.kitServer.title, campo: campoIsLoop, valor: _isLooping ? 1 : 0);
                          provider.carregarMusicas();
                        });

                        _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioManager {
  static final List<_PadButtonState> _players = [];
  static bool _isStopping = false;
  static int _stopOperationId = 0;

  static void register(_PadButtonState player) {
    _players.add(player);
  }

  static void unregister(_PadButtonState player) {
    _players.remove(player);
  }

  static Future<void> stopAll() async {
    if (_isStopping) return;
    _isStopping = true;
    _stopOperationId++;
    final currentOperationId = _stopOperationId;

    const int steps = 110;
    const durationPerStep = Duration(milliseconds: 10);

    final playersToStop = List<_PadButtonState>.from(_players.where((p) => p._isPlaying && !p._isFading));

    if (playersToStop.isEmpty) {
      _isStopping = false;
      return;
    }

    // 🔥 Trava os players imediatamente
    for (var player in playersToStop) {
      player._isFading = true;
      player._isPlaying = false;
    }

    final Map<_PadButtonState, double> startVolumes = {
      for (var player in playersToStop) player: player._volume,
    };

    for (int i = 0; i <= steps; i++) {
      if (currentOperationId != _stopOperationId) {
        _isStopping = false;
        return;
      }

      final t = i / steps;
      for (var player in playersToStop) {
        final volume = (startVolumes[player]! * (1.0 - t)).clamp(0.0, 1.0);
        player._player.setVolume(volume);

        player.setState(() {
          player._buttonColor = Color.lerp(const Color.fromARGB(255, 52, 118, 188), player.widget.baseColor, t)!;
        });
      }
      await Future.delayed(durationPerStep);
    }

    for (var player in playersToStop) {
      await player._player.stop();
      await player._player.setVolume(player._volume);
      player._isFading = false;
      player.setState(() {
        player._buttonColor = player.widget.baseColor;
      });
    }

    _isStopping = false;
  }
}
