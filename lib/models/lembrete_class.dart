class Lembrete {
  final String texto;
  final double dx;
  final double dy;

  Lembrete({required this.texto, required this.dx, required this.dy});

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'dx': dx,
        'dy': dy,
      };

  factory Lembrete.fromJson(Map<String, dynamic> json) => Lembrete(
        texto: json['texto'],
        dx: json['dx'],
        dy: json['dy'],
      );
}