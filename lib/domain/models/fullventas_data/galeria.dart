class Photo {
  final int id;
  final String descripcion;
  final String fotoUrl;

  Photo({required this.id, required this.descripcion, required this.fotoUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: int.tryParse(json['id'].toString()) ?? 0,

      descripcion: json['descripcion'],
      fotoUrl:
          "http://192.168.18.3/mystore/gull_ventas_php_project/${json['foto_url']}", // Ajusta la URL según tu servidor
    );
  }
}
