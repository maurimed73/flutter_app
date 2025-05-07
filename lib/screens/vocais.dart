import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class VocaisPage extends StatefulWidget {
  @override
  _VocaisPageState createState() => _VocaisPageState();
}

class _VocaisPageState extends State<VocaisPage> {
  final List<String> audioAssets = [
    'assets/music/dias_gloria_lead.mp3',
  ];

  final List<AudioPlayer> players = [];
  final List<bool> isMuted = [];

  @override
  void initState() {
    super.initState();
    //_initPlayers();
    testeArquivo();
    //testAssetLoad();
  }

  Future<void> _initPlayers() async {
    for (var path in audioAssets) {
      final player = AudioPlayer();
      //await player.setAudioSource(AudioSource.asset(path)); //Uri.parse('asset:///$assetPath'
      //  await player.setLoopMode(LoopMode.all);
      //await player.play(); // Toca automaticamente
      players.add(player);
      isMuted.add(false);
    }
    setState(() {});
  }

  void testeArquivo() async {
    final player = AudioPlayer();

    await player.setAudioSource(
      AudioSource.asset('/assets/music/dias_gloria_lead.mp3'),
    );

    await player.play();
  }

  void testAssetLoad() async {
    try {
      await rootBundle.load('assets/music/dias_gloria_lead.mp3');
      print("✔️ O arquivo foi encontrado.");
    } catch (e) {
      print("❌ Erro ao carregar asset: $e");
    }
  }

  void toggleMute(int index) {
    setState(() {
      isMuted[index] = !isMuted[index];
      players[index].setVolume(isMuted[index] ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    for (var player in players) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (players.length != audioAssets.length) {
      return Scaffold(
        appBar: AppBar(title: Text("Reproduzindo Músicas")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Reproduzindo Músicas")),
      body: ListView.builder(
        itemCount: audioAssets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.music_note),
              title: Text("Áudio ${index + 1}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Mudo'),
                  Checkbox(
                    value: isMuted[index],
                    onChanged: (_) => toggleMute(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
