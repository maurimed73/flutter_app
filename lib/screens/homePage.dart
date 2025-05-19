import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/cifraPage.dart';

import 'package:flutter_app/models/music_class.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Music>> _futureMusicas;

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
            title: Container(
          width: 200,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Cerco Jericó 2025',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Text(
                'Nossa Senhora do Rosário',
                style: TextStyle(fontSize: 14, color: Colors.amber),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CifraPage(
                                music: music,
                              )),
                      //MaterialPageRoute(builder: (context) => CifraPage()),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Imagem grande
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
                          // Título e descrição
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                  ),
                );

                // ListTile(
                //   minVerticalPadding: 5.0,
                //   leading: Image.network(music.imageUrl,
                //       width: 100, height: 150, fit: BoxFit.fill),
                //   title: Text(
                //     music.title,
                //     style: TextStyle(fontSize: 30),
                //   ),
                //   subtitle:
                //       Text(music.description, style: TextStyle(fontSize: 18)),
                //   onTap: () {
                //     // Abrir link ou PDF
                //     print('Abrir: ${music.linkUrl}');
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => CifraPage(
                //                 music: music,
                //               )),
                //       //MaterialPageRoute(builder: (context) => CifraPage()),
                //     );
                //   },
                // );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
