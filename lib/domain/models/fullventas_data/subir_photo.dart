class Foto {
  final int id;
  final String description;
  final int clienteId;
  final String estado;
  final DateTime fechaCreacion;
  final String fotoUrl;

  Foto({
    required this.id,
    required this.description,
    required this.clienteId,
    required this.estado,
    required this.fechaCreacion,
    required this.fotoUrl,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'],
      description: json['description'],
      clienteId: json['cliente_id'],
      estado: json['estado'], // Convierte bit(1) a bool
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fotoUrl: json['turl_foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'cliente_id': clienteId,
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'turl_foto': fotoUrl,
    };
  }
}
