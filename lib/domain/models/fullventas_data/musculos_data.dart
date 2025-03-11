import 'dart:convert';

List<MusculosData> musculosDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => MusculosData.fromJson(item)).toList();
}

String musculosDataToJson(MusculosData? data) => json.encode(data!.toJson());

class MusculosData {
  const MusculosData({
    this.id_musculo,
    this.id_grupo,
    this.nombre_musculo,
  });

  final int? id_musculo;
  final int? id_grupo;
  final String? nombre_musculo;

  factory MusculosData.fromJson(Map<String, dynamic> json) => MusculosData(
      id_musculo: int.tryParse(json['id_musculo'].toString()) ?? 0,
      id_grupo: int.tryParse(json['id_grupo'].toString()) ?? 0,
      nombre_musculo: json['nombre_musculo'] as String?);

  Map<String, dynamic> toJson() => {
        "id_musculo": id_musculo,
        "id_grupo": id_grupo,
        "nombre_musculo": nombre_musculo,
      };
}
