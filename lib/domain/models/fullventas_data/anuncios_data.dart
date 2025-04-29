import 'dart:convert';

List<AnunciosData> publicidadDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => AnunciosData.fromJson(item)).toList();
}

String publicidadDataToJson(AnunciosData? data) => json.encode(data!.toJson());

class AnunciosData {
  const AnunciosData({
    this.fecha_fin,
    this.fecha_inicio,
    this.id,
    this.seccion,
    this.url_imagen,
    this.url_redes,
  });

  final DateTime? fecha_fin;
  final DateTime? fecha_inicio;
  final int? id;
  final String? seccion;
  final String? url_imagen;
  final List<String>? url_redes;

  factory AnunciosData.fromJson(Map<String, dynamic> json) => AnunciosData(
        fecha_fin: json['fecha_fin'] != null
            ? DateTime.tryParse(json['fecha_fin'].toString())
            : null,
        fecha_inicio: json['fecha_inicio'] != null
            ? DateTime.tryParse(json['fecha_inicio'].toString())
            : null,
        id: int.tryParse(json['id'].toString()) ?? 0,
        seccion: json['seccion'] as String?,
        url_imagen: json['url_imagen'] as String?,
        url_redes: (json['url_redes'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "fecha_fin": fecha_fin?.toIso8601String(),
        "fecha_inicio": fecha_inicio?.toIso8601String(),
        "id": id,
        "seccion": seccion,
        "url_imagen": url_imagen,
        "url_redes": url_redes,
      };
}
