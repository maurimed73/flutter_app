class KitServer {
  final String title;
  final String imageUrl;
  final String description;
  final String refstorage;
  final String sound1Nome;
  final String sound2Nome;
  final String sound3Nome;
  final String sound4Nome;
  final String sound1Patch;
  final String sound2Patch;
  final String sound3Patch;
  final String sound4Patch;
  final double sound1Volume;
  final double sound2Volume;
  final double sound3Volume;
  final double sound4Volume;
  final int isLoop1;
  final int isLoop2;
  final int isLoop3;
  final int isLoop4;

  KitServer(
      {required this.title,
      required this.imageUrl,
      required this.description,
      required this.refstorage,
      required this.sound1Nome,
      required this.sound2Nome,
      required this.sound3Nome,
      required this.sound4Nome,
      required this.sound1Patch,
      required this.sound2Patch,
      required this.sound3Patch,
      required this.sound4Patch,
      required this.sound1Volume,
      required this.sound2Volume,
      required this.sound3Volume,
      required this.sound4Volume,
      required this.isLoop1,
      required this.isLoop2,
      required this.isLoop3,
      required this.isLoop4});

  factory KitServer.fromJson(Map<String, dynamic> json) {
    return KitServer(
        title: json['title'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        refstorage: json['refstorage'],
        sound1Nome: json['sound1Nome'],
        sound2Nome: json['sound2Nome'],
        sound3Nome: json['sound3Nome'],
        sound4Nome: json['sound4Nome'],
        sound1Patch: json['sound1Patch'],
        sound2Patch: json['sound2Patch'],
        sound3Patch: json['sound3Patch'],
        sound4Patch: json['sound4Patch'],
        sound1Volume: (json['sound1Volume'] as num).toDouble(),
        sound2Volume: (json['sound2Volume'] as num).toDouble(),
        sound3Volume: (json['sound3Volume'] as num).toDouble(),
        sound4Volume: (json['sound4Volume'] as num).toDouble(),
        isLoop1: (json['isLoop1']),
        isLoop2: (json['isLoop2']),
        isLoop3: (json['isLoop3']),
        isLoop4: (json['isLoop4']));
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'refstorage': refstorage,
      'sound1Nome': sound1Nome,
      'sound2Nome': sound2Nome,
      'sound3Nome': sound3Nome,
      'sound4Nome': sound4Nome,
      'sound1Patch': sound1Patch,
      'sound2Patch': sound2Patch,
      'sound3Patch': sound3Patch,
      'sound4Patch': sound4Patch,
      'sound1Volume': sound1Volume,
      'sound2Volume': sound2Volume,
      'sound3Volume': sound3Volume,
      'sound4Volume': sound4Volume,
      'isLoop1': isLoop1,
      'isLoop2': isLoop2,
      'isLoop3': isLoop3,
      'isLoop4': isLoop4
    };
  }
}
