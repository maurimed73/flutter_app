import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/cifraPage.dart';
import 'package:flutter_app/database/music_database.dart';

import 'package:flutter_app/models/music_class.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Music>> _futureMusicas;
  Icon iconDown = Icon(
    Icons.download,
    size: 50,
  );
  String status = "Aguardando...";
  Map<String, String> downloadStatus = {}; // título da música -> status
  @override
  void initState() {
    super.initState();
    _futureMusicas = carregarMusicas();
  }

  Future<List<Music>> carregarMusicas() async {
    final firestore = FirebaseFirestore.instance;
    //final storage = FirebaseStorage.instance;

    final snapshot = await firestore.collection('cercoNSR').get();

    List<Music> musicas = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      // final title = data['title'];
      // final description = data['description'];
      // final linkUrl = data['linkUrl'];

      // // Caminhos no Storage
      // final imagePath = data['imageUrl'];
      // final pdfPath = data['pdfUrl'];

      var music1 = Music.fromMap(data);

      // musicas.add(Music(
      //   title: title,
      //   description: description,
      //   imageUrl: imagePath,
      //   pdfUrl: pdfPath,
      //   linkUrl: linkUrl,
      // ));
      musicas.add(music1);
    }

    return musicas;
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 110,
            actions: [
              IconButton(
                  onPressed: () {
                    deletarMusicas();
                    setState(() {});
                  },
                  icon: Icon(Icons.delete))
            ],
            title: Container(
              width: 300,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Cerco Jericó 2025',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                  const Text(
                    'Nossa Senhora do Rosário',
                    style: TextStyle(fontSize: 14, color: Colors.amber),
                  ),
                  Text(
                    'Repertório',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            )),
        body: FutureBuilder<List<Music>>(
          future: _futureMusicas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhuma música encontrada.'));
            }

            final musicas = snapshot.data!;

            return ListView(
              children: musicas.map((music) {
                final status = downloadStatus[music.title] ?? 'idle';

                return FutureBuilder<bool>(
                  future: MusicDatabase.instance.isMusicDownloaded(music.title),
                  builder: (context, snapshot) {
                    final isDownloaded = snapshot.data ?? false;

                    return Material(
                      color: Colors.transparent, // mantém fundo do Card intacto
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (isDownloaded || status == 'concluido') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CifraPage(
                                    music: music), // substitua pela sua página
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    music.imageUrl,
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        music.title,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        music.description,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Ação do botão/texto
                                if (status == 'baixando')
                                  Text("Baixando...",
                                      style: TextStyle(fontSize: 14))
                                else if (status == 'deletando')
                                  Text("Deletando...",
                                      style: TextStyle(fontSize: 14))
                                else if (isDownloaded || status == 'concluido')
                                  Row(
                                    children: [
                                      Icon(Icons.check,
                                          size: 40, color: Colors.green),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever,
                                            color: Colors.red, size: 30),
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Confirmar exclusão'),
                                              content: Text(
                                                  'Tem certeza que deseja apagar o download desta música?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text('Apagar',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            setState(() {
                                              downloadStatus[music.title] =
                                                  'deletando';
                                            });

                                            await deletarPastaMusica(
                                                music.description);
                                            await MusicDatabase.instance
                                                .deleteMusicByTitle(
                                                    music.title);

                                            setState(() {
                                              downloadStatus[music.title] =
                                                  ''; // volta pro ícone de download
                                            });
                                          }
                                        },
                                      )
                                    ],
                                  )
                                else
                                  IconButton(
                                    icon: Icon(Icons.download,
                                        size: 40, color: Colors.grey),
                                    onPressed: () async {
                                      setState(() {
                                        downloadStatus[music.title] =
                                            'baixando';
                                      });

                                      //await baixarMusica(music.description);
                                      await baixarArquivosDaPasta(
                                          music.description);
                                      await MusicDatabase.instance
                                          .insertMusic(music);

                                      setState(() {
                                        downloadStatus[music.title] =
                                            'concluido';
                                      });
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
            );
          },
        ),
      ),
    );
  }

  void deletarMusicas() async {
    // print(music.title);
    final db = MusicDatabase.instance;

    await db.deleteAllMusics();
    // Limpa os status de download para que volte ao ícone de download
    setState(() {
      downloadStatus
          .clear(); // limpa todos os status para forçar ícone de download
    });
  }

  Future<void> baixarArquivosDaPasta(String nomePasta) async {
    setState(() => status = "Baixando...");
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
