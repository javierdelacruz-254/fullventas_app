import 'dart:convert';

List<GrupoMuscularesData> grupoMuscularesDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => GrupoMuscularesData.fromJson(item)).toList();
}

String grupoMuscularesDataToJson(GrupoMuscularesData? data) =>
    json.encode(data!.toJson());

class GrupoMuscularesData {
  const GrupoMuscularesData({
    this.id_grupo,
    this.nombre_grupo,
    this.image_name,
  });

  final int? id_grupo;
  final String? nombre_grupo;
  final String? image_name;

  factory GrupoMuscularesData.fromJson(Map<String, dynamic> json) =>
      GrupoMuscularesData(
          id_grupo: int.tryParse(json['id_grupo'].toString()) ?? 0,
          nombre_grupo: json['nombre_grupo'] as String?,
          image_name: json['image_name'] as String?);

  Map<String, dynamic> toJson() => {
        "id_grupo": id_grupo,
        "nombre_grupo": nombre_grupo,
        "image_name": image_name,
      };
}
