// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/models/music_class.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CifraPage extends StatefulWidget {
  final Music music;
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

    // final pdfFileTemp = await downloadFile('pdf/${widget.music.pdfUrl}');

    setState(() {
      pdfFile = File(filePath);
      loading = false;
    });
  }

  // Future<File> downloadFile(String firebasePath) async {
  //   final ref = FirebaseStorage.instance.ref().child(firebasePath);
  //   final bytes = await ref.getData();
  //   final dir = await getTemporaryDirectory();
  //   final file = File('${dir.path}/${firebasePath.split('/').last}');
  //   await file.writeAsBytes(bytes!);
  //   return file;
  // }

  // Future<void> togglePlayPause() async {
  //   if (isPlaying) {
  //     await audioPlayer.pause();
  //     setState(() => isPlaying = false);
  //   } else {
  //     if (current == Duration.zero) {
  //       setState(() => isLoading = true); // começa o loading
  //       try {
  //         String url = await FirebaseStorage.instance
  //             .ref(widget.music.linkUrl)
  //             .getDownloadURL();
  //         await audioPlayer.play(UrlSource(url));
  //         setState(() => isPlaying = true);
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Erro ao carregar música')),
  //         );
  //       } finally {
  //         setState(() => isLoading = false); // termina o loading
  //       }
  //     } else {
  //       await audioPlayer.resume();
  //       setState(() => isPlaying = true);
  //     }
  //   }
  // }

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

  // Future<void> playFromFirebase() async {
  //   String url = await FirebaseStorage.instance
  //       .ref(widget.music.linkUrl) // caminho no Storage
  //       .getDownloadURL();

  //   if (isPlaying) {
  //   } else {
  //     await audioPlayer.play(UrlSource(url)); // streaming direto
  //   }

  //   setState(() => isPlaying = true);
  // }

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
              style: TextStyle(fontSize: 24),
            )),
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 0, top: 0, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
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
                          isPlaying ? 'Pausar' : 'Tocar',
                          style: TextStyle(fontSize: 24),
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
              ),
              loading
                  ? SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: PDFView(
                              filePath: pdfFile!.path,
                              autoSpacing: false,
                              swipeHorizontal: false,
                              enableSwipe: true,
                              pageFling: false,
                            ),
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
