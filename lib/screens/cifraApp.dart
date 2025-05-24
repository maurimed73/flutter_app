// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/database/cifra_repository.dart';

import 'package:flutter_app/provider/music_provider.dart';

class CifraApp extends StatefulWidget {
  CifraApp({
    Key? key,
  }) : super(key: key);

  @override
  State<CifraApp> createState() => _CifraAppState();
}

class _CifraAppState extends State<CifraApp> {
  int transpose = 0;

  // List<List<BlocoCifra>> linhasFirebase = [
  //   [
  //     BlocoCifra(acorde: "A9", texto: "Passei"),
  //     BlocoCifra(acorde: "", texto: " anos no "),
  //     BlocoCifra(acorde: "F#m7", texto: "deserto"),
  //     BlocoCifra(acorde: "", texto: " "),
  //     BlocoCifra(acorde: "C#m7", texto: "Pra"),
  //     BlocoCifra(acorde: "", texto: " chegar à "),
  //     BlocoCifra(acorde: "E", texto: "Canaã"),
  //   ],
  //   [],
  //   [
  //     BlocoCifra(acorde: "A9", texto: "Minha"),
  //     BlocoCifra(acorde: "", texto: " terra "),
  //     BlocoCifra(acorde: "F#m7", texto: "prometida"),
  //     BlocoCifra(acorde: "", texto: "Terra de uma nova"),
  //     BlocoCifra(acorde: "G#m7", texto: "vida"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Livre da escra"),
  //     BlocoCifra(acorde: "C#m7", texto: "vidão"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "A9", texto: "Apren"),
  //     BlocoCifra(acorde: "", texto: "di que as ba"),
  //     BlocoCifra(acorde: "F#m7", texto: "talhas "),
  //     BlocoCifra(acorde: "C#m7", texto: "Eu as"),
  //     BlocoCifra(acorde: "", texto: " venço no Se"),
  //     BlocoCifra(acorde: "E", texto: "nhor"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "A9", texto: "Sus"),
  //     BlocoCifra(acorde: "", texto: "tentado por Sua"),
  //     BlocoCifra(acorde: "F#m7", texto: "Graça"),
  //     BlocoCifra(acorde: "", texto: " Revestido da "),
  //     BlocoCifra(acorde: "G#m7", texto: "couraça"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Dando brados de "),
  //     BlocoCifra(acorde: "C#m7", texto: "louvor"),
  //     BlocoCifra(acorde: "E", texto: "          "),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "E mes"),
  //     BlocoCifra(acorde: "", texto: "mo ontem, hoje e sem"),
  //     BlocoCifra(acorde: "B", texto: "pre"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "F#m7", texto: "Não "),
  //     BlocoCifra(acorde: "", texto: "há outro Deus "),
  //     BlocoCifra(acorde: "C#m7", texto: "igual. "),
  //     BlocoCifra(acorde: "", texto: "Vou celebrar dias de "),
  //     BlocoCifra(acorde: "A/", texto: "gló"),
  //     BlocoCifra(acorde: "C#", texto: "ria"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Uma nova traj"),
  //     BlocoCifra(acorde: "F#/", texto: "etó"),
  //     BlocoCifra(acorde: "C#", texto: "ria"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Tocar o sobre"),
  //     BlocoCifra(acorde: "G#4", texto: "natu"),
  //     BlocoCifra(acorde: "", texto: "ral"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "C#m", texto: "Mura"),
  //     BlocoCifra(acorde: "", texto: "lhas "),
  //     BlocoCifra(acorde: "A", texto: "cairão"),
  //     BlocoCifra(acorde: "", texto: ", dias de glória "),
  //     BlocoCifra(acorde: "E", texto: "então"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Eu vive"),
  //     BlocoCifra(acorde: "B", texto: "rei,"),
  //     BlocoCifra(acorde: "", texto: " eu v"),
  //     BlocoCifra(acorde: "C#m", texto: "iverei"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Para procla"),
  //     BlocoCifra(acorde: "A", texto: "mar:"),
  //     BlocoCifra(acorde: "", texto: " Meu Deus abriu o "),
  //     BlocoCifra(acorde: "E", texto: "mar"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Deserto já pass"),
  //     BlocoCifra(acorde: "B", texto: "ou."),
  //     BlocoCifra(acorde: "", texto: " Vitória,"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Enfim, "),
  //     BlocoCifra(acorde: "C#m", texto: "chegou"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "A9", texto: "Dias"),
  //     BlocoCifra(acorde: "", texto: " de glória,"),
  //     BlocoCifra(acorde: "F#m7", texto: " eu "),
  //     BlocoCifra(acorde: "", texto: "viverei"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "C#m7", texto: "Mural"),
  //     BlocoCifra(acorde: "", texto: "has cairão, mu"),
  //     BlocoCifra(acorde: "B", texto: "ral"),
  //     BlocoCifra(acorde: "", texto: "has cairão, oh"),
  //     BlocoCifra(acorde: "A", texto: "oh"),
  //   ],
  // ];

  List<List<BlocoCifra>> linhas = [];

  String transporAcorde(String acorde, int transp) {
    final notas = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];
    final acordeBase = RegExp(r'[A-G][#b]?').stringMatch(acorde);
    if (acordeBase == null) return acorde;

    final index = notas.indexOf(acordeBase);
    if (index == -1) return acorde;

    final novoIndex = (index + transp) % 12;
    final nota = notas[novoIndex < 0 ? novoIndex + 12 : novoIndex];

    return acorde.replaceFirst(acordeBase, nota);
  }

  @override
  void initState() {
    super.initState();
    cifraFuture = repo.carregarLinhasCifra(
      'dias_gloria',
    );
    //exemploUso();
    //enviarMusicaFirebase();
  }

//   void enviarMusicaFirebase() async {
// // 🔥 Salvar no Firebase
//     await repo.salvarCifra('dias_gloria', linhasFirebase);
//   }

  // void exemploUso() async {
  //   final repo = CifraRepository();

  //   // 🔥 Buscar do Firebase
  //   //linhas = await repo.buscarCifra('dias_gloria');

  //   // print(resultado);

  //   // 🔥 Salvar no Firebase
  //   await repo.salvarCifra('dias_gloria', linhasFirebase);
  // }

  final repo = CifraRepository();
  late Future<List<List<BlocoCifra>>> cifraFuture;

  @override
  Widget build(BuildContext context) {
    final cifraconfig = context.read<MusicProvider>();
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    print(' largura é: $largura');
    print(' altura é: $altura');
    return Consumer<MusicProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              //ESCOLHA DO TAMANHO DA FONTE
              Container(
                width: largura < 400
                    ? 100
                    : 120, // 🔥 Aumentei proporcionalmente, ajuste como quiser
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 202, 196, 198),
                  ),
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    // Primeiro A
                    GestureDetector(
                      onTap: cifraconfig.fontDecrement,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 242, 242),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8))),
                        width: largura < 400 ? 30 : 80, // ,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'A',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Texto do meio (Texto ou Restaurar)
                    Container(
                      width: largura < 400 ? 38 : 80, // ,
                      color: const Color.fromARGB(255, 243, 242, 242),
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Texto', // 🔄 Muda para "Texto" dinamicamente
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    // Segundo A
                    GestureDetector(
                      onTap: cifraconfig.fontIncrement,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 242, 242),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        width: largura < 400 ? 30 : 80, // ,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'A',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              // ESCOLHA DA CIFRA
              Container(
                width: largura < 400
                    ? 100
                    : 120, // 🔥 Aumentei proporcionalmente, ajuste como quiser
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 202, 196, 198),
                  ),
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    // Primeiro A
                    GestureDetector(
                      onTap: cifraconfig.trasposicaoDecrement,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 242, 242),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8))),
                        width: largura < 400 ? 30 : 80, // ,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '-',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: largura < 400 ? 38 : 80, // ,
                      color: const Color.fromARGB(255, 243, 242, 242),
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\u00BD Tom', // 🔄 Muda para "Texto" dinamicamente
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    // Segundo A
                    GestureDetector(
                      onTap: cifraconfig.trasposicaoIncrement,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 242, 242),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        width: largura < 400 ? 30 : 80, // ,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '+',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       exemploUso();
            //     },
            //     icon: Icon(Icons.data_array))
          ],
        ),
        body: FutureBuilder<List<List<BlocoCifra>>>(
          future: cifraFuture, // 🔥 Future fixo aqui
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma cifra encontrada.'));
            }

            final linhas = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: linhas.map((linha) {
                    return LinhaCifra(
                      blocos: linha,
                      transpose: value.transpose,
                      transporAcorde: transporAcorde,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LinhaCifra extends StatelessWidget {
  final List<BlocoCifra> blocos;
  final int transpose;
  final String Function(String, int) transporAcorde;

  const LinhaCifra({
    super.key,
    required this.blocos,
    required this.transpose,
    required this.transporAcorde,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 1,
          runSpacing: 1,
          children: blocos.map((bloco) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bloco.acorde != null
                      ? transporAcorde(bloco.acorde!, transpose)
                      : '',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: value.fonteTamanho,
                  ),
                ),
                Text(
                  bloco.texto,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: value.fonteTamanho,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BlocoCifra {
  final String? acorde;
  final String texto;

  BlocoCifra({this.acorde, required this.texto});

  Map<String, dynamic> toMap() {
    return {
      'acorde': acorde,
      'texto': texto,
    };
  }

  factory BlocoCifra.fromMap(Map<String, dynamic> map) {
    return BlocoCifra(
      acorde: map['acorde'],
      texto: map['texto'] ?? '',
    );
  }
}

class Musica {
  final String id;
  final String titulo;
  final String artista;
  final Map<String, List<BlocoCifra>> linhas;

  Musica({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.linhas,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'artista': artista,
      'linhas': linhas.map(
        (key, value) => MapEntry(
          key,
          value.map((bloco) => bloco.toMap()).toList(),
        ),
      ),
    };
  }

  factory Musica.fromMap(String id, Map<String, dynamic> map) {
    return Musica(
      id: id,
      titulo: map['titulo'] ?? '',
      artista: map['artista'] ?? '',
      linhas: (map['linhas'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((bloco) => BlocoCifra.fromMap(bloco))
              .toList(),
        ),
      ),
    );
  }
}
