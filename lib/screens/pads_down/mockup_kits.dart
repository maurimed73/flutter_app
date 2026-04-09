import 'package:PadsBuga/models/music_class_server.dart';
import 'package:flutter/material.dart';

class MockupKitsProvider extends ChangeNotifier {
  List<KitServer> _kits = [];

  List<KitServer> get kits => [..._kits];

  Future<void> loadKits(kits) async {
    // Simulando um carregamento, pode ser do Firestore
    _kits = kits;
    // _kits = [
    //   KitServer(
    //       title: 'Worship D+',
    //       imageUrl: '',
    //       description: 'Oração e Adoração',
    //       refstorage: 'worshipD+',
    //       sound1Nome: 'WarmPad',
    //       sound2Nome: 'Vocoder',
    //       sound3Nome: 'CymbalEvolution',
    //       sound4Nome: 'Chimes',
    //       sound1Patch: '',
    //       sound2Patch: '',
    //       sound3Patch: '',
    //       sound4Patch: '',
    //       sound1Volume: 1.0,
    //       sound2Volume: 0.6,
    //       sound3Volume: 0.4,
    //       sound4Volume: 0.4),
    //   KitServer(
    //       title: 'Worship D+',
    //       imageUrl: '',
    //       description: 'Oração e Adoração',
    //       refstorage: 'worshipD+',
    //       sound1Nome: 'WarmPad',
    //       sound2Nome: 'Vocoder',
    //       sound3Nome: 'CymbalEvolution',
    //       sound4Nome: 'Chimes',
    //       sound1Patch: '',
    //       sound2Patch: '',
    //       sound3Patch: '',
    //       sound4Patch: '',
    //       sound1Volume: 1.0,
    //       sound2Volume: 0.6,
    //       sound3Volume: 0.4,
    //       sound4Volume: 0.4),
    // ];

    notifyListeners();
  }
}
