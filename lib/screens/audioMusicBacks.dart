// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/music_class.dart';

class audioMusicBacks {
  final String linkUrl;
  audioMusicBacks(
    this.linkUrl,
  );
}

class AudioListPage extends StatefulWidget {
  Music music;
  AudioListPage({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  final List<audioMusicBacks> audioList = [];

  AudioPlayer? _audioPlayer;
  int? _currentlyPlayingIndex;
  List<String> versos = [];
  bool isPlaying = false;

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    listaBacks();
    super.initState();
  }

  void _playPause(String verso, int index) async {
    if (_currentlyPlayingIndex == index) {
      await _audioPlayer?.pause();

      setState(() {
        _currentlyPlayingIndex = index;
        isPlaying = false;
      });
    } else {
      _audioPlayer?.stop();
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.play(UrlSource(verso));
      setState(() => _currentlyPlayingIndex = index);
      _audioPlayer!.onPlayerComplete.listen((event) {
        setState(() => _currentlyPlayingIndex = null);
      });
    }
  }

  void listaBacks() {
    versos = widget.music.backs.values.map((e) => e.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.music.backs);

    print(versos);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Áudios'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: versos.length,
        itemBuilder: (context, index) {
          final audio = versos[index];
          final isPlaying = _currentlyPlayingIndex == index;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.music_note, color: Colors.deepPurple),
              title: Text('back ${index + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white)),
              trailing: IconButton(
                icon: Icon(isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill),
                color: Colors.deepPurple,
                iconSize: 32,
                onPressed: () => _playPause(versos[index], index),
              ),
            ),
          );
        },
      ),
    );
  }
}
