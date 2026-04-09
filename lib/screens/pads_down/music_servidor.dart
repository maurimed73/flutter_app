import 'dart:io';

import 'package:PadsBuga/database/kit_database_model.dart';
import 'package:PadsBuga/provider/music_provider.dart';
import 'package:PadsBuga/screens/pads_down/mockup_kits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:PadsBuga/utils/responsive_utils.dart';

import 'package:PadsBuga/models/music_class_server.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class KitServidor extends StatefulWidget {
  const KitServidor({super.key});

  @override
  State<KitServidor> createState() => _KitServidorState();
}

class _KitServidorState extends State<KitServidor> {
  late Future<List<KitServer>> _futureKits;
  Map<String, String> downloadStatus = {}; // título da música -> status

  @override
  void initState() {
    super.initState();
    _futureKits = carregarMusicas();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<MockupKitsProvider>(context, listen: false)
    //       .loadKits(_futureKits);
    // });
  }

  Future<List<KitServer>> carregarMusicas() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('Kits')
        .get(const GetOptions(source: Source.server));

    List<KitServer> kits = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      var kit = KitServer.fromJson(data);
      kits.add(kit);
    }

    return kits;
  }

  //tocar direto no firebase
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isDownloaded = false;
  String? url;

  Future<void> loadAudio(String kit) async {}

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kits = Provider.of<MockupKitsProvider>(context).kits;
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
                  'Pads',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scalePercent(context, 6),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<List<KitServer>>(
          future: _futureKits,
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
                    future: KitDatabaseMobile.instance
                        .isMusicDownloaded(music.title),
                    builder: (context, snapshot) {
                      final isDownloaded = snapshot.data ?? false;
                      final musicProvider = Provider.of<MusicProvider>(context);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (isDownloaded || status == 'concluido') {}
                          },
                          child: Container(
                            height: 60,
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Icon(
                                                Icons.track_changes,
                                                color: Colors.pink,
                                              )),
                                          const SizedBox(width: 16),
                                          Text(
                                            music.title,
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveUtils.scalePercent(
                                                      context, 3.5),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Padding(
                                          //     padding: const EdgeInsets.only(
                                          //         left: 20),
                                          //     child: IconButton(
                                          //         onPressed: () async {
                                          //           if (player.playing) {
                                          //             player.pause();
                                          //             setState(() =>
                                          //                 isPlaying = false);
                                          //           }
                                          //           else {
                                          //             try {
                                          //               // Caminho do arquivo no Firebase Storage
                                          //               final ref = FirebaseStorage
                                          //                   .instance
                                          //                   .ref()
                                          //                   .child(
                                          //                       '${music.refstorage}/Warm.mp3');

                                          //               // Obtem a URL de download temporária
                                          //               url = await ref
                                          //                   .getDownloadURL();

                                          //               // Carrega no player
                                          //               await player
                                          //                   .setUrl(url!);
                                          //               print(
                                          //                   'Áudio carregado com sucesso!');
                                          //             } catch (e) {
                                          //               print(
                                          //                   'Erro ao carregar áudio: $e');
                                          //             }
                                          //             player.play();
                                          //             setState(() =>
                                          //                 isPlaying = true);
                                          //           }
                                          //           print('escutar música');
                                          //         },
                                          //         icon: Icon(isPlaying
                                          //             ? Icons.stop
                                          //             : Icons.headphones)))
                                        ],
                                      ),
                                    ),
                                    if (status == 'baixando')
                                      Lottie.asset(
                                        'assets/downloads/animation_download.json',
                                        width: ResponsiveUtils.scalePercent(
                                            context, 10),
                                        height: ResponsiveUtils.scalePercent(
                                            context, 10),
                                      )
                                    else if (isDownloaded ||
                                        status == 'concluido')
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: ResponsiveUtils.scalePercent(
                                                context, 5),
                                            color: Colors.green,
                                          ),

                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Comprado',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          // IconButton(
                                          //   icon: Icon(
                                          //     Icons.delete_forever,
                                          //     color: Colors.red,
                                          //     size:
                                          //         ResponsiveUtils.scalePercent(
                                          //             context, 8),
                                          //   ),
                                          //   onPressed: () async {
                                          //     final confirm =
                                          //         await showDialog<bool>(
                                          //       context: context,
                                          //       builder: (context) =>
                                          //           AlertDialog(
                                          //         title: const Text(
                                          //             'Confirmar exclusão'),
                                          //         content: const Text(
                                          //             'Tem certeza que deseja apagar os dados locais desta música?'),
                                          //         actions: [
                                          //           TextButton(
                                          //             onPressed: () =>
                                          //                 Navigator.pop(
                                          //                     context, false),
                                          //             child: const Text(
                                          //                 'Cancelar'),
                                          //           ),
                                          //           TextButton(
                                          //             onPressed: () =>
                                          //                 Navigator.pop(
                                          //                     context, true),
                                          //             child: const Text(
                                          //               'Apagar',
                                          //               style: TextStyle(
                                          //                   color: Colors.red),
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     );

                                          //     if (confirm == true) {
                                          //       provider.setDownloadStatus(
                                          //           music.title, 'deletando');

                                          //       await deletarPastaMusica(
                                          //           music.title);
                                          //       await KitDatabaseMobile.instance
                                          //           .deleteMusicByTitle(
                                          //               music.title);
                                          //       musicProvider
                                          //           .deletarMusica(music.title);
                                          //       musicProvider.carregarMusicas();

                                          //       setState(() {
                                          //         downloadStatus[music.title] =
                                          //             '';
                                          //       });
                                          //     }
                                          //   },
                                          // )
                                        ],
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('Comprar'),
                                          IconButton(
                                            icon: Icon(
                                              Icons.download,
                                              size:
                                                  ResponsiveUtils.scalePercent(
                                                      context, 5),
                                              color: Colors.grey,
                                            ),
                                            onPressed: () async {
                                              provider.setDownloadStatus(
                                                  music.title, 'baixando');
                                              await KitDatabaseMobile.instance
                                                  .insertMusic(music);

                                              Map<String, String> listaSouds =
                                                  await baixarArquivosDaPasta(
                                                      music.refstorage);

                                              await KitDatabaseMobile.instance
                                                  .updateMusicParam(
                                                      title: music.title,
                                                      campo: 'sound1Patch',
                                                      valor: listaSouds.entries
                                                          .elementAt(0)
                                                          .value);
                                              await KitDatabaseMobile.instance
                                                  .updateMusicParam(
                                                      title: music.title,
                                                      campo: 'sound2Patch',
                                                      valor: listaSouds.entries
                                                          .elementAt(1)
                                                          .value);
                                              await KitDatabaseMobile.instance
                                                  .updateMusicParam(
                                                      title: music.title,
                                                      campo: 'sound3Patch',
                                                      valor: listaSouds.entries
                                                          .elementAt(2)
                                                          .value);
                                              await KitDatabaseMobile.instance
                                                  .updateMusicParam(
                                                      title: music.title,
                                                      campo: 'sound4Patch',
                                                      valor: listaSouds.entries
                                                          .elementAt(3)
                                                          .value);

                                              musicProvider.carregarMusicas();
                                              provider.setDownloadStatus(
                                                  music.title, 'concluido');

                                              print(
                                                  'musica 4 -> ---------------------------- ${music.sound4Nome}');
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
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

        //     body: 2 != 2
        //         ? const Center(child: CircularProgressIndicator())
        //         : ListView.builder(
        //             itemCount: kits.length,
        //             itemBuilder: (ctx, i) {
        //               final kit = kits[i];
        //               return ListTile(
        //                 title: Text(kit.title),
        //                 subtitle: 2 == 2
        //                     ? const Text('Comprado',
        //                         style: TextStyle(color: Colors.green))
        //                     : const Text('Disponível para compra'),
        //                 trailing: 2 == 2
        //                     ? const Icon(Icons.check, color: Colors.green)
        //                     : ElevatedButton(
        //                         onPressed: () {},
        //                         child: const Text('Comprar'),
        //                       ),
        //               );
        //             },
        //           ),
      ),
    );
  }

  void deletarMusicas() async {
    final db = KitDatabaseMobile.instance;
    await db.deleteAllMusics();

    setState(() {
      downloadStatus.clear();
    });
  }

  Future<Map<String, String>> baixarArquivosDaPasta(String nomePasta) async {
    try {
      Map<String, String> listaSounds = {};
      final storageRef = FirebaseStorage.instance.ref().child(nomePasta);
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

        // Adiciona no mapa o nome do arquivo sem extensão (opcional) e o caminho local
        final nomeSemExtensao = fileName.split('.').first;
        listaSounds[nomeSemExtensao] = filePath;
      }
      return listaSounds;
    } catch (e) {
      print('Erro ao baixar arquivos da pasta: $e');
      return {};
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
