class Ejercicio {
  final int idEjercicio;
  final String nombre;
  final String descripcion;
  final String? foto2;
  final String? foto3;
  final String nombreMusculo;
  final String? video1;

  Ejercicio({
    required this.idEjercicio,
    required this.nombre,
    required this.descripcion,
    this.foto2,
    this.foto3,
    required this.nombreMusculo,
    this.video1,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      idEjercicio: json['id_ejercicio'] is int
          ? json['id_ejercicio']
          : int.tryParse(json['id_ejercicio'].toString()) ??
              0, // Conversión segura
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      foto2: json['foto_2'],
      foto3: json['foto_3'],
      nombreMusculo: json['nombre_musculo'],
      video1: json['video_1'],
    );
  }
}
