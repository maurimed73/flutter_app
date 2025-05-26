class MusicServer {
  final String title;
  final String imageUrl;
  final String description;
  final String pdfUrl;
  final String linkUrl;
  final String tomOriginal;
  final Map<String, dynamic> backs;

  MusicServer({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.pdfUrl,
    required this.linkUrl,
    required this.tomOriginal,
    this.backs = const {},
  });

  factory MusicServer.fromMap(Map<String, dynamic> map) {
    return MusicServer(
      tomOriginal: map['tomOriginal'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      linkUrl: map['linkUrl'] ?? '',
      backs: Map<String, dynamic>.from(map['backs'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tomOriginal': tomOriginal,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'pdfUrl': pdfUrl,
      'linkUrl': linkUrl,
      'backs': backs,
    };
  }
}
