import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/database/cifra_repository.dart';
import 'package:flutter_app/screens/cifraApp.dart';

import 'package:path_provider/path_provider.dart';

class ConfigMusica extends StatefulWidget {
  const ConfigMusica({Key? key}) : super(key: key);

  @override
  State<ConfigMusica> createState() => _ConfigMusicaState();
}

class _ConfigMusicaState extends State<ConfigMusica> {
  String uploadStatus = '';
  String? fileUrl;
  final repo = CifraRepository();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Música DIAS DE GLÓRIA - TOM E
  List<List<BlocoCifra>> resultCifra = [
    [
      BlocoCifra(acorde: "A9", texto: "Passei"),
      BlocoCifra(acorde: "", texto: " anos no "),
      BlocoCifra(acorde: "F#m7", texto: "deserto"),
      BlocoCifra(acorde: "", texto: " "),
      BlocoCifra(acorde: "C#m7", texto: "Pra"),
      BlocoCifra(acorde: "", texto: " chegar à "),
      BlocoCifra(acorde: "E", texto: "Canaã"),
    ],
    [],
    [
      BlocoCifra(acorde: "A9", texto: "Minha"),
      BlocoCifra(acorde: "", texto: " terra "),
      BlocoCifra(acorde: "F#m7", texto: "prometida"),
      BlocoCifra(acorde: "", texto: "Terra de uma nova"),
      BlocoCifra(acorde: "G#m7", texto: "vida"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Livre da escra"),
      BlocoCifra(acorde: "C#m7", texto: "vidão"),
    ],
    [
      BlocoCifra(acorde: "A9", texto: "Apren"),
      BlocoCifra(acorde: "", texto: "di que as ba"),
      BlocoCifra(acorde: "F#m7", texto: "talhas "),
      BlocoCifra(acorde: "C#m7", texto: "Eu as"),
      BlocoCifra(acorde: "", texto: " venço no Se"),
      BlocoCifra(acorde: "E", texto: "nhor"),
    ],
    [
      BlocoCifra(acorde: "A9", texto: "Sus"),
      BlocoCifra(acorde: "", texto: "tentado por Sua "),
      BlocoCifra(acorde: "F#m7", texto: "Graça"),
      BlocoCifra(acorde: "", texto: " Revestido da "),
      BlocoCifra(acorde: "G#m7", texto: "couraça"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Dando brados de "),
      BlocoCifra(acorde: "C#m7", texto: "louvor"),
      BlocoCifra(acorde: "E", texto: "          "),
    ],
    [
      BlocoCifra(acorde: "", texto: "E mes"),
      BlocoCifra(acorde: "", texto: "mo ontem, hoje e sem"),
      BlocoCifra(acorde: "B", texto: "pre"),
    ],
    [
      BlocoCifra(acorde: "F#m7", texto: "Não "),
      BlocoCifra(acorde: "", texto: "há outro Deus "),
      BlocoCifra(acorde: "C#m7", texto: "igual. "),
      BlocoCifra(acorde: "", texto: "Vou celebrar dias de "),
      BlocoCifra(acorde: "A/", baixo: "C#", texto: "glória"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Uma nova "),
      BlocoCifra(acorde: "F#/", baixo: "C#", texto: "trajetória"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Tocar o sobre"),
      BlocoCifra(acorde: "G#4", texto: "natu"),
      BlocoCifra(acorde: "", texto: "ral"),
    ],
    [
      BlocoCifra(acorde: "C#m", texto: "Mura"),
      BlocoCifra(acorde: "", texto: "lhas "),
      BlocoCifra(acorde: "A", texto: "cairão"),
      BlocoCifra(acorde: "", texto: ", dias de glória "),
      BlocoCifra(acorde: "E", texto: "então"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Eu vive"),
      BlocoCifra(acorde: "B", texto: "rei,"),
      BlocoCifra(acorde: "", texto: " eu v"),
      BlocoCifra(acorde: "C#m", texto: "iverei"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Para procla"),
      BlocoCifra(acorde: "A", texto: "mar:"),
      BlocoCifra(acorde: "", texto: " Meu Deus abriu o "),
      BlocoCifra(acorde: "E", texto: "mar"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Deserto já pass"),
      BlocoCifra(acorde: "B", texto: "ou."),
      BlocoCifra(acorde: "", texto: " Vitória,"),
    ],
    [
      BlocoCifra(acorde: "", texto: "Enfim, "),
      BlocoCifra(acorde: "A9", texto: "chegou"),
    ],
    [
      BlocoCifra(acorde: "", texto: "1º vez - A9, 2º C#m, 3º A9"),
    ],
    [
      BlocoCifra(acorde: "A9", texto: "Dias"),
      BlocoCifra(acorde: "", texto: " de glória,"),
      BlocoCifra(acorde: "F#m7", texto: " eu "),
      BlocoCifra(acorde: "", texto: "viverei"),
    ],
    [
      BlocoCifra(acorde: "C#m7", texto: "Mural"),
      BlocoCifra(acorde: "", texto: "has cairão, mu"),
      BlocoCifra(acorde: "B", texto: "ral"),
      BlocoCifra(acorde: "", texto: "has cairão, oh"),
      BlocoCifra(acorde: "A", texto: "oh"),
    ],
  ];

  //************************************************************************************************* */
  // ✅ Converte List<List<BlocoCifra>> em JSON válido para Firestore
  List<Map<String, dynamic>> linhasParaJson(List<List<BlocoCifra>> linhas) {
    return linhas.asMap().entries.map((entry) {
      return {
        'index': entry.key,
        'blocos': entry.value.map((b) => b.toMap()).toList(),
      };
    }).toList();
  }

  // 🔥 Salvar cifra
  Future<void> salvarCifra(String id, List<List<BlocoCifra>> linhas) async {
    final data = {'linhas': linhasParaJson(linhas)};
    prettyPrintJson(data);
    //firestore.collection('cercoNSR').doc(id).update(data);

    //await firestore.collection('cifras').doc(id).set(data);
  }

  /// Salva o Map como arquivo JSON no dispositivo
  Future<File> salvarJsonEmArquivo(
      Map<String, dynamic> data, String nomeArquivo) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$nomeArquivo.json');

    final jsonString = jsonEncode(data);
    return file.writeAsString(jsonString);
  }

  /// Envia o arquivo para o Firebase Storage
  Future<String> enviarArquivoParaStorage(
      File file, String caminhoNoStorage) async {
    final ref = FirebaseStorage.instance.ref().child(caminhoNoStorage);
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return url;
  }

  /// Apaga o arquivo local do dispositivo
  Future<void> deletarArquivoLocal(File file) async {
    if (await file.exists()) {
      await file.delete();
      print('Arquivo local deletado: ${file.path}');
    } else {
      print('Arquivo não encontrado para deletar.');
    }
  }

  void prettyPrintJson(Map jsonObject) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(jsonObject);
    debugPrint(prettyString);
  }

  void exemploUso() async {
    final repo = CifraRepository();

    // 🔥 Buscar do Firebase
    //linhas = await repo.buscarCifra('dias_gloria');

    // print(resultado);

    // 🔥 Salvar no Firebase
    await salvarCifra('dias_gloria', resultCifra);
  }

  void enviarMusicaFirebase(String nomeMusica) async {
// 🔥 Salvar no Firebase
    await salvarCifra('dias_gloria', resultCifra);
  }

  //************************************************************************************************************** */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload de Arquivos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                //            id no firebase           Json criado
                //salvarCifra('Y7bTdyKfagSkqeyXscvD', linhasDiasDeGloria);
                final data = {'linhas': linhasParaJson(resultCifra)};

                final arquivo = await salvarJsonEmArquivo(data, 'dias_gloria');

                final url = await enviarArquivoParaStorage(
                  arquivo,
                  '/music/dias_gloria/',
                );

                print('Arquivo enviado! URL: $url');

                await deletarArquivoLocal(arquivo);
              },
              child: const Text('Enviar Música'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // String status = '';
  // String? downloadUrl;

  // Future<void> uploadFile() async {
  //   final result = await FilePicker.platform.pickFiles();

  //   if (result == null) {
  //     setState(() {
  //       status = 'Nenhum arquivo selecionado.';
  //     });
  //     return;
  //   }

  //   final file = result.files.first;
  //   final fileBytes = file.bytes;
  //   final fileName = file.name;

  //   setState(() {
  //     status = 'Enviando $fileName...';
  //   });

  //   try {
  //     final ref = FirebaseStorage.instance.ref('uploads/$fileName');

  //     await ref.putData(fileBytes!);

  //     final url = await ref.getDownloadURL();

  //     setState(() {
  //       status = 'Upload concluído!';
  //       downloadUrl = url;
  //     });

  //   } catch (e) {
  //     setState(() {
  //       status = 'Erro: $e';
  //     });
  //   }
  // }
}

// Músicas já cadastradas no Firebase
//1- documento: I6pQRSuPevjmdI6GPll3   música Dias de Glória
//2- documento: Y7bTdyKfagSkqeyXscvD   música Tu És
//1- documento: oRZy4fdbxvYChRGXcDdH   música Algo Novo
