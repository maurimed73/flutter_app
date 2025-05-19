import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String status = "Aguardando...";

  // Future<void> baixarMusica(String nomeArquivo) async {
  //   setState(() => status = "Verificando permissões...");

  //   // Solicitar permissão (Android)
  //   if (Platform.isAndroid) {
  //     var statusPermissao = await Permission.storage.request();
  //     if (!statusPermissao.isGranted) {
  //       setState(() => status = "Permissão negada.");
  //       return;
  //     }
  //   }

  //   try {
  //     setState(() => status = "Buscando URL...");

  //     final ref = FirebaseStorage.instance.ref().child('music/$nomeArquivo');
  //     final url = await ref.getDownloadURL();

  //     final dir = await getApplicationDocumentsDirectory();
  //     final filePath = '${dir.path}/$nomeArquivo';

  //     setState(() => status = "Baixando...");

  //     await Dio().download(url, filePath);

  //     setState(() => status = "Download concluído: $filePath");
  //   } catch (e) {
  //     setState(() => status = "Erro: $e");
  //   }
  // }

  Future<void> baixarMusica(String nomeArquivo) async {
    setState(() => status = "Baixando...");

    try {
      final ref = FirebaseStorage.instance.ref().child('music/$nomeArquivo');
      final url = await ref.getDownloadURL();

      final dir = await getApplicationDocumentsDirectory();

      // Cria uma pasta com o nome do arquivo (sem extensão, se desejar)
      final folderName = nomeArquivo.replaceAll('.mp3', ''); // opcional
      final targetDir = Directory('${dir.path}/$folderName');

      if (!(await targetDir.exists())) {
        await targetDir.create(recursive: true);
      }

      final filePath = '${targetDir.path}/$nomeArquivo';

      await Dio().download(url, filePath);

      setState(() => status = "Download salvo em: $filePath");
    } catch (e) {
      setState(() => status = "Erro: $e");
    }
  }

  Future<void> listarArquivosLocais() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path).listSync();

    for (var file in files) {
      if (file is File) {
        print('Arquivo: ${file.path}');
      }
    }
  }

  Future<void> listarDiretorios() async {
    final dir = await getApplicationDocumentsDirectory();
    final entries = Directory(dir.path).listSync();

    for (var entry in entries) {
      if (entry is Directory) {
        print('Diretório: ${entry.path}');
      }
    }
  }

  Future<void> listarArquivosDoDiretorio(String nomeDiretorio) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dirPath = '${appDir.path}/$nomeDiretorio';
    final dir = Directory(dirPath);

    if (await dir.exists()) {
      final arquivos = dir.listSync();

      for (var arquivo in arquivos) {
        if (arquivo is File) {
          print('Arquivo: ${arquivo.path}');
        }
      }
    } else {
      print('Diretório não encontrado: $dirPath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baixar Música')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => baixarMusica("Algo_Novo.mp3"),
              child: Text("Baixar Algo Novo.mp3"),
            ),
            ElevatedButton(
              onPressed: () {
                listarArquivosLocais();
              },
              child: Text("listar músicas baixada"),
            ),
            ElevatedButton(
              onPressed: () {
                listarDiretorios();
              },
              child: Text("listar diretórios"),
            ),
            ElevatedButton(
              onPressed: () {
                listarArquivosDoDiretorio('Algo_Novo');
              },
              child: Text("listar arquivos dentro do diretórios"),
            ),
          ],
        ),
      ),
    );
  }
}
