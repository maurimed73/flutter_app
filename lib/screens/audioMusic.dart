// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class MultiAudioPlayerPage extends StatefulWidget {
//   @override
//   _MultiAudioPlayerPageState createState() => _MultiAudioPlayerPageState();
// }

// class _MultiAudioPlayerPageState extends State<MultiAudioPlayerPage> {
//   final List<AudioPlayer> players = [];
//   final List<bool> isMuted = [];
//   final List<String> audioUrls = [
//     'https://example.com/audio1.mp3',
//     'https://example.com/audio2.mp3',
//     'https://example.com/audio3.mp3',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     for (var url in audioUrls) {
//       final player = AudioPlayer();
//       player.setUrl(url);
//       player.setLoopMode(LoopMode.all);
//       player.play();
//       players.add(player);
//       isMuted.add(false);
//     }
//   }

//   @override
//   void dispose() {
//     for (var player in players) {
//       player.dispose();
//     }
//     super.dispose();
//   }

//   void toggleMute(int index) {
//     setState(() {
//       isMuted[index] = !isMuted[index];
//       players[index].setVolume(isMuted[index] ? 0.0 : 1.0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Multi Áudio com Mute e Forma de Onda')),
//       body: ListView.builder(
//         itemCount: audioUrls.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.all(12),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(16),
//               title: Text('Áudio ${index + 1}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Aqui entraria o widget de waveform (ver nota abaixo)
//                   Placeholder(fallbackHeight: 60), // Simula waveform
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text('Mudo'),
//                       Checkbox(
//                         value: isMuted[index],
//                         onChanged: (_) => toggleMute(index),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
