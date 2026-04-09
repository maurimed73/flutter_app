import 'dart:async';
import 'package:PadsBuga/database/kit_database_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../models/music_class_server.dart';

class MusicProvider with ChangeNotifier {
  List<KitServer> _musicas = [];
  List<KitServer> get musicas => _musicas;
  bool carregando = true;

  final _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  MusicaProvider() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // Se voltou a ter internet
        carregarMusicas();
      }
    });
  }

  int _transpose = 0;
  int get transpose => _transpose;

  double _fontTamanho = 14.0;
  double get fonteTamanho => _fontTamanho;

  /// define a transposição positiva
  void trasposicaoIncrement() {
    _transpose++;
    notifyListeners();
  }

  /// define a transposição negativa
  void trasposicaoDecrement() {
    _transpose--;
    notifyListeners();
  }

  /// define a transposição positiva
  void fontIncrement() {
    _fontTamanho = _fontTamanho + 2;
    notifyListeners();
  }

  /// define a transposição negativa
  void fontDecrement() {
    _fontTamanho = _fontTamanho - 2;
    notifyListeners();
  }

  Future<void> carregarMusicas() async {
    carregando = true;

    notifyListeners();
    final tempoMinimo = Future.delayed(Duration(seconds: 2));
    try {
      final db = KitDatabaseMobile.instance;
      _musicas = await db.getAllMusics();
    } catch (e) {
      _musicas = [];
    }

    await tempoMinimo; // Espera pelo menos 7 segundos
    carregando = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

   /// Deleta uma música pelo ID
  Future<void> deletarMusica(String title) async {
    final db = KitDatabaseMobile.instance;
    await db.deleteMusicByTitle(title);
    await carregarMusicas();
  }

  /// Deleta todas as músicas
  Future<void> deletarTodas() async {
    final db = KitDatabaseMobile.instance;
    await db.deleteAllMusics();
    await carregarMusicas();
  }

  Map<String, String> _downloadStatus = {}; // título -> status

  Map<String, String> get downloadStatus => _downloadStatus;

  void setDownloadStatus(String title, String status) {
    _downloadStatus[title] = status;
    notifyListeners();
  }

  void clearDownloadStatus() {
    _downloadStatus.clear();
    notifyListeners();
  }

  String getStatus(String title) {
    return _downloadStatus[title] ?? 'idle';
  }
}
