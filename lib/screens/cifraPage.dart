// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/models/music_class_server.dart';
import 'package:flutter_app/provider/music_provider.dart';
import 'package:flutter_app/screens/audio_music_backs.dart';
import 'package:flutter_app/screens/cifraApp.dart';

import 'package:flutter_app/utils/responsive_utils.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CifraPage extends StatefulWidget {
  final MusicServer music;
  const CifraPage({
    super.key,
    required this.music,
  });
  @override
  _CifraPageState createState() => _CifraPageState();
}

class _CifraPageState extends State<CifraPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  bool loading = true;
  Duration current = Duration.zero;
  Duration total = Duration.zero;
  File? pdfFile;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    loadPdf(widget.music.description);

    audioPlayer.onPositionChanged.listen((d) {
      setState(() => current = d);
    });
    audioPlayer.onDurationChanged.listen((d) {
      setState(() => total = d);
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        current = Duration.zero;
      });
    });
  }

  Future<void> loadPdf(String pdf) async {
    String bancoMusica = pdf;

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$bancoMusica/$bancoMusica.pdf';

    setState(() {
      pdfFile = File(filePath);
      loading = false;
    });
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      if (current == Duration.zero) {
        setState(() => isLoading = true); // começa o loading
        try {
          final directory = await getApplicationDocumentsDirectory();
          final localPath =
              '${directory.path}/${widget.music.description}/${widget.music.description}.mp3';
          final file = File(localPath);

          if (await file.exists()) {
            // 🎵 Toca do arquivo local
            await audioPlayer.play(DeviceFileSource(file.path));
            setState(() => isPlaying = true);
          } else {
            // 🔁 Se não existe localmente, tenta o Firebase como fallback
            // String url = await FirebaseStorage.instance
            //     .ref(widget.music.linkUrl)
            //     .getDownloadURL();
            // await audioPlayer.play(UrlSource(url));
            // setState(() => isPlaying = true);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar música: $e')),
          );
        } finally {
          setState(() => isLoading = false); // termina o loading
        }
      } else {
        await audioPlayer.resume();
        setState(() => isPlaying = true);
      }
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (isPlaying) {
          // Impede de voltar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pause a música para sair',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),

              backgroundColor: const Color.fromARGB(255, 223, 200, 130),
              behavior:
                  SnackBarBehavior.floating, // necessário para usar margin
              margin: EdgeInsets.all(20), // define a margem
              shape: RoundedRectangleBorder(
                // opcional: cantos arredondados
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 4),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text(
            widget.music.title,
            style: TextStyle(
              fontSize: ResponsiveUtils.scalePercent(context, 6),
            ),
          ),
        ),
        body: isFullScreen
            ? Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      Expanded(
                        child: CifraApp(),
                      ),
                      Positioned(
                        top: 5,
                        right: 20,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black54,
                          mini: true,
                          onPressed: () {
                            setState(() => isFullScreen = false);
                          },
                          child: Icon(
                            Icons.close,
                            size: ResponsiveUtils.scalePercent(context, 6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : _buildNormalView(context),
      ),
    );
  }

  Widget _buildNormalView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: isLoading ? null : togglePlayPause,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 26,
                          ),
                          SizedBox(width: 10),
                          Text(
                            isPlaying ? 'Stop' : 'Play',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.scalePercent(context, 4),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: isPlaying
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BacksMusic(
                                          music: widget.music,
                                        )),
                              );
                            },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mic,
                            size: 26,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Vocais',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.scalePercent(context, 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
          Slider(
            value: current.inSeconds.toDouble(),
            max: total.inSeconds.toDouble(),
            onChanged: (value) {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Text(
            '${current.inMinutes}:${(current.inSeconds % 60).toString().padLeft(2, '0')}'
            ' / '
            '${total.inMinutes}:${(total.inSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: ResponsiveUtils.scalePercent(context, 4),
            ),
          ),
          loading
              ? SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          child: CifraApp(),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 10,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.black54,
                          onPressed: () {
                            setState(() => isFullScreen = true);
                          },
                          child: Icon(
                            Icons.fullscreen,
                            size: ResponsiveUtils.scalePercent(context, 6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
