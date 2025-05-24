import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class DownloadProvider with ChangeNotifier {
  Map<String, String> downloadStatus = {}; // título -> status ('idle', 'baixando', 'concluido')

  /// Começa o download da pasta da música
  Future<void> downloadMusicFolder(String nomePasta, String title) async {
    downloadStatus[title] = 'baixando';
    notifyListeners();

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

      downloadStatus[title] = 'concluido';
      notifyListeners();
    } catch (e) {
      downloadStatus[title] = 'erro';
      notifyListeners();
      print('Erro ao baixar arquivos da pasta: $e');
    }
  }

  /// Deleta pasta local da música
  Future<void> deleteMusicFolder(String nomePasta, String title) async {
    downloadStatus[title] = 'deletando';
    notifyListeners();

    try {
      final dir = await getApplicationDocumentsDirectory();
      final folderPath = '${dir.path}/$nomePasta';

      final folder = Directory(folderPath);

      if (await folder.exists()) {
        await folder.delete(recursive: true);
        print("Pasta deletada com sucesso.");
      } else {
        print("Pasta não encontrada.");
      }

      downloadStatus[title] = 'idle';
      notifyListeners();
    } catch (e) {
      downloadStatus[title] = 'erro';
      notifyListeners();
      print("Erro ao deletar pasta: $e");
    }
  }
}
