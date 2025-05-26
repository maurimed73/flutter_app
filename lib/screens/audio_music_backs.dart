// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:flutter_app/models/music_class_server.dart';

class BacksMusic extends StatefulWidget {
  MusicServer music;
  BacksMusic({
    super.key,
    required this.music,
  });

  @override
  State<BacksMusic> createState() => _BacksMusicState();
}

class _BacksMusicState extends State<BacksMusic> {
  List<FileSystemEntity> musicFiles = [];
  final Map<String, AudioPlayer> players = {};
  String? currentPlaying;

  @override
  void initState() {
    super.initState();
    loadMusics();
  }

  // Future<void> loadMusicFiles() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final musicDir = Directory('${dir.path}/dias_gloria');

  //   if (await musicDir.exists()) {
  //     final files =
  //         musicDir.listSync().where((f) => f.path.endsWith('.mp3')).toList();
  //     setState(() {
  //       musicFiles = files;
  //     });
  //   }
  // }

  Future<void> loadMusics() async {
    // final status = await Permission.storage.request();
    // if (!status.isGranted) return;

    // Caminho da pasta de músicas
    final directory = await getApplicationDocumentsDirectory();
    //final localPath = '${directory.path}/${widget.music.description}/';
    final Directory dir =
        Directory('${directory.path}/${widget.music.description}/');
    if (await dir.exists()) {
      final files = dir.listSync().where((f) {
        return f.path.endsWith('.mp3') &&
            !f.path.endsWith('${widget.music.description}.mp3');
      }).toList();
      //print(files);
      setState(() {
        musicFiles = files;
      });
    }
  }

  Future<void> togglePlay(String path) async {
    final isSame = currentPlaying == path;

    // Parar player atual se clicou no mesmo
    if (isSame && players[path]?.playing == true) {
      await players[path]?.stop();
      setState(() {
        currentPlaying = null;
      });
      return;
    }

    // Parar player anterior
    if (currentPlaying != null && currentPlaying != path) {
      await players[currentPlaying!]?.stop();
    }

    if (!players.containsKey(path)) {
      final player = AudioPlayer();
      await player.setAudioSource(AudioSource.uri(Uri.file(path)));
      players[path] = player;

      // Captura duração
      final duration = await player.duration;
      if (duration != null) {
        durations[path] = duration;
      }

      // Ouve mudanças no estado do player
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.stop(); // Garante que pare completamente
          if (currentPlaying == path) {
            setState(() {
              currentPlaying = null;
            });
          }
        } else {
          setState(() {}); // Atualiza ícone e cor durante transições
        }
      });
    }

    currentPlaying = path;

    final player = players[path]!;

    // Reinicia sempre do início
    await player.seek(Duration.zero);
    await player.play();

    setState(() {});
  }

  Map<String, Duration> durations = {};

  @override
  void dispose() {
    for (var player in players.values) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.music.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Sessões ",
          style: TextStyle(
            fontSize: ResponsiveUtils.scalePercent(context, 6),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: musicFiles.isEmpty
            ? Center(child: Text("Nenhum audio encontrado."))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // dois por linha
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: musicFiles.length,
                itemBuilder: (context, index) {
                  final file = musicFiles[index];
                  final path = file.path;
                  final name = p.basenameWithoutExtension(path);
                  final isPlayingNow =
                      currentPlaying == path && players[path]?.playing == true;
                  final duration = durations[path];
                  final formattedDuration = duration != null
                      ? "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}"
                      : "--:--";

                  return GestureDetector(
                    onTap: () => togglePlay(path),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isPlayingNow
                            ? const Color.fromARGB(255, 198, 146, 3)
                            : const Color.fromARGB(255, 236, 212, 133),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPlayingNow ? Icons.pause : Icons.play_arrow,
                            size: ResponsiveUtils.scalePercent(context, 12),
                            color: isPlayingNow
                                ? Colors.deepPurple
                                : Colors.black54,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${widget.music.title} ${index + 1}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  ResponsiveUtils.scalePercent(context, 3),
                            ),
                          ),
                          SizedBox(height: 8),
                          // Text(
                          //   "⏱ $formattedDuration",
                          //   style: TextStyle(
                          //     fontSize: 26,
                          //     color: isPlayingNow ? Colors.black : Colors.black,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
