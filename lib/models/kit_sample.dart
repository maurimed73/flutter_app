// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class KitSample {
  String nomePad1;
  String nomePad2;
  String nomePad3;
  String nomePad4;
  double volume1;
  double volume2;
  double volume3;
  double volume4;
  String sound1;
  String sound2;
  String sound3;
  String sound4;
  bool isPlaying;
  KitSample({
    required this.nomePad1,
    required this.nomePad2,
    required this.nomePad3,
    required this.nomePad4,
    required this.volume1,
    required this.volume2,
    required this.volume3,
    required this.volume4,
    required this.sound1,
    required this.sound2,
    required this.sound3,
    required this.sound4,
    required this.isPlaying,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomePad1': nomePad1,
      'nomePad2': nomePad2,
      'nomePad3': nomePad3,
      'nomePad4': nomePad4,
      'volume1': volume1,
      'volume2': volume2,
      'volume3': volume3,
      'volume4': volume4,
      'sound1': sound1,
      'sound2': sound2,
      'sound3': sound3,
      'sound4': sound4,
      'isPlaying': isPlaying,
    };
  }

  factory KitSample.fromMap(Map<String, dynamic> map) {
    return KitSample(
      nomePad1: map['nomePad1'] as String,
      nomePad2: map['nomePad2'] as String,
      nomePad3: map['nomePad3'] as String,
      nomePad4: map['nomePad4'] as String,
      volume1: map['volume1'] as double,
      volume2: map['volume2'] as double,
      volume3: map['volume3'] as double,
      volume4: map['volume4'] as double,
      sound1: map['sound1'] as String,
      sound2: map['sound2'] as String,
      sound3: map['sound3'] as String,
      sound4: map['sound4'] as String,
      isPlaying: map['isPlaying'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory KitSample.fromJson(String source) =>
      KitSample.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'KitSample(nomePad1: $nomePad1, nomePad2: $nomePad2, nomePad3: $nomePad3, nomePad4: $nomePad4, volume1: $volume1, volume2: $volume2, volume3: $volume3, volume4: $volume4, sound1: $sound1, sound2: $sound2, sound3: $sound3, sound4: $sound4, isPlaying: $isPlaying)';
  }

  @override
  bool operator ==(covariant KitSample other) {
    if (identical(this, other)) return true;

    return other.nomePad1 == nomePad1 &&
        other.nomePad2 == nomePad2 &&
        other.nomePad3 == nomePad3 &&
        other.nomePad4 == nomePad4 &&
        other.volume1 == volume1 &&
        other.volume2 == volume2 &&
        other.volume3 == volume3 &&
        other.volume4 == volume4 &&
        other.sound1 == sound1 &&
        other.sound2 == sound2 &&
        other.sound3 == sound3 &&
        other.sound4 == sound4 &&
        other.isPlaying == isPlaying;
  }

  @override
  int get hashCode {
    return nomePad1.hashCode ^
        nomePad2.hashCode ^
        nomePad3.hashCode ^
        nomePad4.hashCode ^
        volume1.hashCode ^
        volume2.hashCode ^
        volume3.hashCode ^
        volume4.hashCode ^
        sound1.hashCode ^
        sound2.hashCode ^
        sound3.hashCode ^
        sound4.hashCode ^
        isPlaying.hashCode;
  }
}
