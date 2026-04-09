import 'dart:io';
import 'dart:ui';
import 'package:PadsBuga/authentication/auth_service.dart';
import 'package:PadsBuga/database/kit_database_model.dart';
import 'package:PadsBuga/main.dart';
import 'package:PadsBuga/screens/pads/music_pad.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PadsBuga/provider/music_provider.dart';
import 'package:PadsBuga/screens/pads_down/music_servidor.dart';
import 'package:PadsBuga/utils/responsive_utils.dart';
import 'package:PadsBuga/models/music_class_server.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicMobile extends StatefulWidget {
  const MusicMobile({
    super.key,
  });

  @override
  State<MusicMobile> createState() => _MusicMobileState();
}

class _MusicMobileState extends State<MusicMobile> {
  late Future<List<KitServer>> _futureMusicas;
  int numeroMusicas = 0;
  Icon iconDown = Icon(
    Icons.download,
    size: 50,
  );
  String status = "Aguardando...";
  Map<String, String> downloadStatus = {}; // título da música -> status
  @override
  void initState() {
    super.initState();
    carregarNome();
    Future.microtask(() => Provider.of<MusicProvider>(context, listen: false).carregarMusicas());
    //_futureMusicas = listarMusicas();
  }

  String nome = 'Usuário';
  String email = "E-mail";

  Future<void> carregarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('displayName') ?? 'Usuário';
      email = prefs.getString('email') ?? 'E-mail';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 100,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.black),
                  accountName: Text('Bem vindo $nome'),
                  accountEmail: Text(email),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(), // 🧽 Empurra os itens seguintes para o final
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text('Deslogar'),
                onTap: () async {
                  AuthService().deslogar();
                  // Opcional: limpar dados locais
                  //final prefs = await SharedPreferences.getInstance();
                  //await prefs.clear();

                  if (context.mounted) {
                    Navigator.pop(context); // Fecha o drawer
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoteadorTelas(),
                        ));
                  }
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ConfigMusica(),
                      //   ),
                      // );
                    },
                    icon: Icon(Icons.data_array)),
              )
            ],
            toolbarHeight: ResponsiveUtils.scalePercent(context, 25),
            title: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'PadsBuga',
                        style: TextStyle(fontSize: ResponsiveUtils.scalePercent(context, 6), color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    'Repertório',
                    style: TextStyle(fontSize: ResponsiveUtils.scalePercent(context, 4), color: Colors.white),
                  ),
                ],
              ),
            )),
        body: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_image.png'),
                    fit: BoxFit.cover, // Faz a imagem preencher todo o container
                  ),
                ),
              ),
            ),
            // 🔹 Desfoque
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // ajuste o blur
              child: Container(
                color: const Color.fromARGB(255, 22, 18, 10) //#16120A
                    .withOpacity(0.8), // camada escura
              ),
            ),
            // 🔹 Conteúdo da página (lista)
            SafeArea(child: Consumer<MusicProvider>(
              builder: (context, provider, _) {
                final musicas = provider.musicas;
                final carregando = provider.carregando; // você define isso no seu provider

                if (carregando) {
                  return Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            'Aguarde alguns instantes',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 30,
                            width: 150,
                            child: Lottie.asset('assets/downloads/dotsBig.json', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return Center(
                  //   child: Lottie.asset(
                  //       'assets/downloads/animation_download.json',
                  //       width: 200),
                  // );
                }

                if (musicas.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma música encontrada',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: musicas.length,
                  itemBuilder: (context, index) {
                    final music = musicas[index];

                    return ListTile(
                      leading: Icon(Icons.music_note, color: Colors.amber),
                      title: Text(music.title),
                      subtitle: Text(music.description ?? 'Artista desconhecido'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text('Tem certeza que deseja apagar os dados locais desta música?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Apagar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            provider.setDownloadStatus(music.title, 'deletando');

                            await deletarPastaMusica(music.description);
                            await KitDatabaseMobile.instance.deleteMusicByTitle(music.title);
                            provider.deletarMusica(music.title);
                            provider.carregarMusicas();
                          }
                        },
                      ),
                      onTap: () {
                        print(music.title);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MusicPad(music: music),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KitServidor(),
                  ));
            }),
      ),
    );
  }

  void deletarMusicas() async {
    // print(music.title);
    final db = KitDatabaseMobile.instance;

    await db.deleteAllMusics();
    // Limpa os status de download para que volte ao ícone de download
    setState(() {
      downloadStatus.clear(); // limpa todos os status para forçar ícone de download
    });
  }

  Future<List<KitServer>> listarMusicas() async {
    final db = KitDatabaseMobile.instance;
    List<KitServer> listaMusicas = await db.getAllMusics();

    numeroMusicas = listaMusicas.length;
    return listaMusicas;
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
