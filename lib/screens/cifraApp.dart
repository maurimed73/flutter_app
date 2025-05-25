// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_app/models/music_class_server.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/database/cifra_repository.dart';

import 'package:flutter_app/provider/music_provider.dart';

class CifraApp extends StatefulWidget {
  final MusicServer music;
  CifraApp({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  State<CifraApp> createState() => _CifraAppState();
}

class _CifraAppState extends State<CifraApp> {
  int transpose = 0;

  // List<List<BlocoCifra>> linhasFirebase = [
  //   [
  //     BlocoCifra(acorde: "F#m", texto: "bUGA"),
  //     BlocoCifra(acorde: "", texto: " promessa "),
  //     BlocoCifra(acorde: "D", texto: "que "),
  //     BlocoCifra(acorde: "", texto: "quer se cumpr"),
  //     BlocoCifra(acorde: "A", texto: "ir "),
  //     BlocoCifra(acorde: "", texto: "em meio a nós"),
  //     BlocoCifra(acorde: "E", texto: "    "),
  //   ],
  //   [],
  //   [
  //     BlocoCifra(acorde: "F#m", texto: "É o"),
  //     BlocoCifra(acorde: "", texto: " próprio Senhor "),
  //     BlocoCifra(acorde: "D", texto: "quem "),
  //     BlocoCifra(acorde: "", texto: "diz: "),
  //     BlocoCifra(acorde: "A", texto: "pedi"),
  //     BlocoCifra(acorde: "", texto: " e "),
  //     BlocoCifra(acorde: "E", texto: "recebereis"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Nenhum "),
  //     BlocoCifra(acorde: "Bm", texto: "mal"),
  //     BlocoCifra(acorde: "", texto: " irá resis"),
  //     BlocoCifra(acorde: "D", texto: "tir"),
  //     BlocoCifra(acorde: "A", texto: " Os mares"),
  //     BlocoCifra(acorde: "", texto: " irão se "),
  //     BlocoCifra(acorde: "E", texto: "abrir"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Quando a "),
  //     BlocoCifra(acorde: "Bm", texto: "boca"),
  //     BlocoCifra(acorde: "", texto: "de Deus decla"),
  //     BlocoCifra(acorde: "D", texto: "rar"),
  //     BlocoCifra(acorde: "A", texto: " Milagres"),
  //     BlocoCifra(acorde: "E", texto: " neste "),
  //     BlocoCifra(acorde: "D", texto: "lugar  "),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Se eu"),
  //     BlocoCifra(acorde: "F#m", texto: "orar,"),
  //     BlocoCifra(acorde: "", texto: " se eu clamar as "),
  //     BlocoCifra(acorde: "D", texto: "muralhas"),
  //     BlocoCifra(acorde: "", texto: "não"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Resisti"),
  //     BlocoCifra(acorde: "A", texto: "rão"),
  //     BlocoCifra(acorde: "", texto: " ao poder de "),
  //     BlocoCifra(acorde: "E", texto: "meu"),
  //     BlocoCifra(acorde: "", texto: "Deus"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Se eu"),
  //     BlocoCifra(acorde: "Gm", texto: "orar,"),
  //     BlocoCifra(acorde: "", texto: " se eu clamar as "),
  //     BlocoCifra(acorde: "D#", texto: "muralhas"),
  //     BlocoCifra(acorde: "", texto: "não"),
  //   ],
  //   [
  //     BlocoCifra(acorde: "", texto: "Resisti"),
  //     BlocoCifra(acorde: "A#", texto: "rão"),
  //     BlocoCifra(acorde: "", texto: " ao poder de "),
  //     BlocoCifra(acorde: "F", texto: "meu"),
  //     BlocoCifra(acorde: "", texto: "Deus"),
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
      widget.music.description,
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
    // List<List<BlocoCifra>> linhasFirebase = [
    //   [
    //     BlocoCifra(acorde: "Bm7", texto: " Junto"),
    //     BlocoCifra(acorde: "", texto: " ao poço, "),
    //     BlocoCifra(acorde: " A/", baixo: "C#", texto: "estava"),
    //     BlocoCifra(acorde: "", texto: " eu. "),
    //     BlocoCifra(acorde: "G2", texto: "Quando"),
    //     BlocoCifra(acorde: "", texto: " um homem judeu."),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Viu a"),
    //     BlocoCifra(acorde: "Bm7", texto: " sede, "),
    //     BlocoCifra(acorde: "", texto: "que "),
    //     BlocoCifra(acorde: "A/", baixo: "C#", texto: "havia"),
    //     BlocoCifra(acorde: "", texto: " em "),
    //     BlocoCifra(acorde: "G2", texto: "mim"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Bm7", texto: "  Sem"),
    //     BlocoCifra(acorde: "", texto: " me ouvir, "),
    //     BlocoCifra(acorde: "A/", baixo: "C#", texto: "conheceu"),
    //     BlocoCifra(acorde: "", texto: " e "),
    //     BlocoCifra(acorde: "G2", texto: "me"),
    //     BlocoCifra(acorde: "", texto: " ofereceu"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Bm7", texto: "Uma água"),
    //     BlocoCifra(acorde: "", texto: " que "),
    //     BlocoCifra(acorde: "A/", baixo: "C#", texto: "jorra"),
    //     BlocoCifra(acorde: "", texto: " sem "),
    //     BlocoCifra(acorde: "G2", texto: "fim"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Em7", texto: "Dá-me"),
    //     BlocoCifra(acorde: "", texto: " de beber pois "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "tenho sede"),
    //     BlocoCifra(acorde: "", texto: ""),
    //     BlocoCifra(acorde: "", texto: ""),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Não quero mais "),
    //     BlocoCifra(acorde: "G2", texto: "buscar em "),
    //     BlocoCifra(acorde: "", texto: "outras "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "Fontes"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Em7", texto: "Não "),
    //     BlocoCifra(acorde: "", texto: "precisarei aqui "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "Voltar"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Pra minha sede "),
    //     BlocoCifra(acorde: "G2", texto: "saciar"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Uma vez que já "),
    //     BlocoCifra(acorde: "A", texto: "ouvi"),
    //     BlocoCifra(acorde: "", texto: " teu falar. "),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Tu"),
    //     BlocoCifra(acorde: "D", texto: "és,"),
    //     BlocoCifra(acorde: "", texto: " por quem a minh'alma "),
    //     BlocoCifra(acorde: "G", texto: "esperou"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "A fonte da vida que"),
    //     BlocoCifra(acorde: "Em7", texto: " me "),
    //     BlocoCifra(acorde: "", texto: "encontrou"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "És o Dom de Deus "),
    //     BlocoCifra(acorde: "G", texto: "o Messias, o meu"),
    //     BlocoCifra(acorde: "A", texto: " Salvador"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "[  ", texto: ""),
    //     BlocoCifra(acorde: "Bm7   ", texto: ""),
    //     BlocoCifra(acorde: "A/", baixo: "C#  ", texto: ""),
    //     BlocoCifra(acorde: "G   ", texto: ""),
    //     BlocoCifra(acorde: "Em7 ]", texto: ""),
    //     BlocoCifra(acorde: "  -  ", texto: ""),
    //     BlocoCifra(acorde: "[  ", texto: ""),
    //     BlocoCifra(acorde: "Bm7   ", texto: ""),
    //     BlocoCifra(acorde: "A/", baixo: "C#  ", texto: ""),
    //     BlocoCifra(acorde: "G ]  ", texto: ""),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Em7", texto: "Dá-me"),
    //     BlocoCifra(acorde: "", texto: " de beber pois "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "tenho sede....."),
    //     BlocoCifra(acorde: "", texto: ""),
    //     BlocoCifra(acorde: "", texto: ""),
    //   ],
    //   [
    //     BlocoCifra(acorde: "D", texto: "Quero "),
    //     BlocoCifra(acorde: "", texto: "beber do teu rio, "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "Senhor"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "G", texto: "Sacia"),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: " minha sede, "),
    //     BlocoCifra(acorde: "", texto: "lava "),
    //     BlocoCifra(acorde: "Em7", texto: "o meu "),
    //     BlocoCifra(acorde: "A", texto: "interior"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "Bm7", texto: "Eu quero "),
    //     BlocoCifra(acorde: "", texto: "fluir em tuas"),
    //     BlocoCifra(acorde: "G", texto: "águas."),
    //     BlocoCifra(acorde: "A", texto: "     "),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Eu"),
    //     BlocoCifra(acorde: "Bm7", texto: "quero"),
    //     BlocoCifra(acorde: "", texto: " beber da tua "),
    //     BlocoCifra(acorde: "G", texto: "fonte"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Fonte de águas "),
    //     BlocoCifra(acorde: "A", texto: "vivas"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "D", texto: "Quero "),
    //     BlocoCifra(acorde: "", texto: "beber do teu rio, "),
    //     BlocoCifra(acorde: "D/", baixo: "F#", texto: "Senhor ..."),
    //     BlocoCifra(acorde: "", texto: " (-- REPETIR --)"),
    //   ],
    //   [
    //     BlocoCifra(acorde: "", texto: "Tu"),
    //     BlocoCifra(acorde: "D", texto: "és,"),
    //     BlocoCifra(acorde: "", texto: " por quem a minh'alma "),
    //     BlocoCifra(acorde: "G", texto: "esperou"),
    //     BlocoCifra(acorde: "", texto: " (-- REPETIR --)"),
    //   ],
    // ];

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
                    : 140, // 🔥 Aumentei proporcionalmente, ajuste como quiser
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
                        width: largura < 400 ? 30 : 40, // ,
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
                      width: largura < 400 ? 38 : 58, // ,
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
                        width: largura < 400 ? 30 : 40, // ,
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
              SizedBox(width: 20),
              // ESCOLHA DA CIFRA
              Container(
                width: largura < 400
                    ? 100
                    : 140, // 🔥 Aumentei proporcionalmente, ajuste como quiser
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
                        width: largura < 400 ? 30 : 40, // ,
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
                      width: largura < 400 ? 38 : 58, // ,
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
                        width: largura < 400 ? 30 : 40, // ,
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

            //ARRUMAR CIFRA
            final linhas = snapshot.data!;
            //final linhas = linhasFirebase;
            BlocoCifra tomMusica = BlocoCifra(texto: "", acorde: "G");
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            'Tom:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: value.fonteTamanho + 8,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '  ${(transporAcorde('E', value.transpose))}',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: value.fonteTamanho + 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: linhas.map((linha) {
                        return LinhaCifra(
                          blocos: linha,
                          transpose: value.transpose,
                          transporAcorde: transporAcorde,
                        );
                      }).toList(),
                    ),
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
    bool isbass = true;
    return Consumer<MusicProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 1,
          runSpacing: 1,
          children: blocos.map((bloco) {
            if (bloco.acorde!.contains('/')) {
              isbass = true;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isbass && bloco.baixo != null
                        ? '${transporAcorde(bloco.acorde!, transpose)}${transporAcorde(bloco.baixo!, transpose)}'
                        : bloco.acorde != null
                            ? '${transporAcorde(bloco.acorde!, transpose)}'
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
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(
                  //   bloco.acorde != null
                  //       ? '${transporAcorde(bloco.acorde!, transpose)}'
                  //       : '',
                  //   style: TextStyle(
                  //     color: Colors.red,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: value.fonteTamanho,
                  //   ),
                  // ),
                  Text(
                    isbass
                        ? '${transporAcorde(bloco.acorde!, transpose)}'
                        : bloco.acorde != null
                            ? '${transporAcorde(bloco.acorde!, transpose)}'
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
            }
          }).toList(),
        ),
      ),
    );
  }
}

class BlocoCifra {
  final String? acorde;
  final String texto;
  final String? baixo;

  BlocoCifra({this.baixo, this.acorde, required this.texto});

  Map<String, dynamic> toMap() {
    return {'acorde': acorde, 'texto': texto, 'baixo': baixo};
  }

  factory BlocoCifra.fromMap(Map<String, dynamic> map) {
    return BlocoCifra(
      baixo: map['baixo'],
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
