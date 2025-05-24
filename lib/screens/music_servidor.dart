import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/provider/music_provider.dart';
import 'package:flutter_app/screens/cifraPage.dart';
import 'package:flutter_app/database/music_database_server.dart';
import 'package:flutter_app/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app/models/music_class_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MusicServidor extends StatefulWidget {
  const MusicServidor({super.key});

  @override
  State<MusicServidor> createState() => _MusicServidorState();
}

class _MusicServidorState extends State<MusicServidor> {
  late Future<List<MusicServer>> _futureMusicas;
  Map<String, String> downloadStatus = {}; // título da música -> status

  @override
  void initState() {
    super.initState();
    _futureMusicas = carregarMusicas();
  }

  Future<List<MusicServer>> carregarMusicas() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('cercoNSR')
        .get(const GetOptions(source: Source.server));

    List<MusicServer> musicas = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      var music = MusicServer.fromMap(data);
      musicas.add(music);
    }

    return musicas;
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: ResponsiveUtils.scalePercent(context, 25),
          title: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cerco Jericó 2025',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scalePercent(context, 6),
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Nossa Senhora do Rosário',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scalePercent(context, 4),
                    color: Colors.amber,
                  ),
                ),
                Text(
                  'Repertório',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scalePercent(context, 4),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<List<MusicServer>>(
          future: _futureMusicas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 158, 156, 156),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Center(
                    child: Text(
                      'Sem Dados',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveUtils.scalePercent(context, 3),
                      ),
                    ),
                  ),
                ),
              );
            }

            final musicas = snapshot.data!;

            return Consumer<MusicProvider>(
              builder: (context, provider, _) => ListView(
                children: musicas.map((music) {
                  final status = provider.getStatus(music.title) ?? 'idle';

                  return FutureBuilder<bool>(
                    future: MusicDatabaseServer.instance
                        .isMusicDownloaded(music.title),
                    builder: (context, snapshot) {
                      final isDownloaded = snapshot.data ?? false;
                      final musicProvider = Provider.of<MusicProvider>(context);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (isDownloaded || status == 'concluido') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CifraPage(music: music),
                                ),
                              );
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      music.imageUrl,
                                      width: ResponsiveUtils.scalePercent(
                                          context, 25),
                                      height: ResponsiveUtils.scalePercent(
                                          context, 20),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          music.title,
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveUtils.scalePercent(
                                                    context, 4.5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (status == 'baixando')
                                    Lottie.asset(
                                      'assets/downloads/animation_download.json',
                                      width: ResponsiveUtils.scalePercent(
                                          context, 25),
                                      height: ResponsiveUtils.scalePercent(
                                          context, 25),
                                    )
                                  else if (isDownloaded ||
                                      status == 'concluido')
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: ResponsiveUtils.scalePercent(
                                              context, 8),
                                          color: Colors.green,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                            size: ResponsiveUtils.scalePercent(
                                                context, 8),
                                          ),
                                          onPressed: () async {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Confirmar exclusão'),
                                                content: const Text(
                                                    'Tem certeza que deseja apagar os dados locais desta música?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child:
                                                        const Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: const Text(
                                                      'Apagar',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              provider.setDownloadStatus(
                                                  music.title, 'deletando');

                                              await deletarPastaMusica(
                                                  music.description);
                                              await MusicDatabaseServer.instance
                                                  .deleteMusicByTitle(
                                                      music.title);
                                              musicProvider
                                                  .deletarMusica(music.title);
                                              musicProvider.carregarMusicas();

                                              setState(() {
                                                downloadStatus[music.title] =
                                                    '';
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  else
                                    IconButton(
                                      icon: Icon(
                                        Icons.download,
                                        size: ResponsiveUtils.scalePercent(
                                            context, 12),
                                        color: Colors.grey,
                                      ),
                                      onPressed: () async {
                                        provider.setDownloadStatus(
                                            music.title, 'baixando');

                                        await baixarArquivosDaPasta(
                                            music.description);
                                        await MusicDatabaseServer.instance
                                            .insertMusic(music);
                                        musicProvider.carregarMusicas();
                                        provider.setDownloadStatus(
                                            music.title, 'concluido');
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void deletarMusicas() async {
    final db = MusicDatabaseServer.instance;
    await db.deleteAllMusics();

    setState(() {
      downloadStatus.clear();
    });
  }

  Future<void> baixarArquivosDaPasta(String nomePasta) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('music/$nomePasta');
      final listResult = await storageRef.listAll();

      final dir = await getApplicationDocumentsDirectory();
      final destino = Directory('${dir.path}/$nomePasta');

      if (!(await destino.exists())) {
        await destino.create(recursive: true);
      }

      for (var item in listResult.items) {
        final url = await item.getDownloadURL();
        final fileName = item.name;
        final filePath = '${destino.path}/$fileName';

        await Dio().download(url, filePath);
        print('✅ Baixado: $filePath');
      }
    } catch (e) {
      print('Erro ao baixar arquivos da pasta: $e');
    }
  }

  Future<void> deletarPastaMusica(String nomeArquivo) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final folderPath = '${dir.path}/${nomeArquivo.replaceAll('.mp3', '')}';

      final folder = Directory(folderPath);

      if (await folder.exists()) {
        await folder.delete(recursive: true);
        print("Pasta deletada com sucesso.");
      } else {
        print("Pasta não encontrada.");
      }
    } catch (e) {
      print("Erro ao deletar pasta: $e");
    }
  }
}
