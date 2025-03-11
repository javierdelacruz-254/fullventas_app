import 'dart:convert';

List<SugerenciasTypeData> sugerenciasTypeDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => SugerenciasTypeData.fromJson(item)).toList();
}

String sugerenciasTypeDataToJson(SugerenciasTypeData? data) =>
    json.encode(data!.toJson());

class SugerenciasTypeData {
  const SugerenciasTypeData({
    this.id,
    this.description,
  });

  final int? id;
  final String? description;

  factory SugerenciasTypeData.fromJson(Map<String, dynamic> json) =>
      SugerenciasTypeData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
