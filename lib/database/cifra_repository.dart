import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/screens/cifraApp.dart';
import 'package:path_provider/path_provider.dart';

class CifraRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ✅ Converte do Firestore para List<List<BlocoCifra>>
  List<List<BlocoCifra>> linhasFromJson(List<dynamic> data) {
    data.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    return data.map<List<BlocoCifra>>((linha) {
      final blocos = (linha['blocos'] as List<dynamic>)
          .map((b) => BlocoCifra.fromMap(b as Map<String, dynamic>))
          .toList();
      return blocos;
    }).toList();
  }

  Future<File> salvarJsonEmArquivo(
      Map<String, dynamic> data, String nomeArquivo) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$nomeArquivo.json');

    final jsonString = jsonEncode(data);
    return file.writeAsString(jsonString);
  }

  //CARREGAR LINHAS CIFRAS
  Future<List<List<BlocoCifra>>> carregarLinhasCifra(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/$id/$id.json';

    final file = File(localPath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(contents);

      return converterJsonParaLinhas(jsonData);
    } else {
      throw Exception('Arquivo não encontrado em $localPath');
    }
  }

  // 🔥 Buscar cifra
  // Future<List<List<BlocoCifra>>> buscarCifra(String id) async {
  //   final doc = await firestore.collection('cifras').doc(id).get();
  //   final directory = await getApplicationDocumentsDirectory();

  //   final localPath = '${directory.path}/$id/$id.json';
  //   final file = File(localPath);
  //   final contents = await file.readAsString();
  //   final Map<String, dynamic> jsonData = jsonDecode(contents);
  //   final linhasDiasDeGloria = converterJsonParaLinhas(jsonData);
  //   print(linhasDiasDeGloria);

  //   if (doc.exists) {
  //     final data = doc.data();
  //     if (data != null && data['linhas'] != null) {
  //       return linhasFromJson(data['linhas']);
  //     }
  //   }

  //   return [];
  // }

  List<List<BlocoCifra>> converterJsonParaLinhas(Map<String, dynamic> json) {
    final linhas = json['linhas'] as List<dynamic>;

    return linhas.map<List<BlocoCifra>>((linha) {
      final blocos = linha['blocos'] as List<dynamic>;
      return blocos.map<BlocoCifra>((bloco) {
        return BlocoCifra.fromMap(bloco);
      }).toList();
    }).toList();
  }
}
