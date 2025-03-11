import 'dart:convert';

List<EstrategiaVentasImageData> estrategiaVentasImageDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData
      .map((item) => EstrategiaVentasImageData.fromJson(item))
      .toList();
}

String estrategiaImageDataToJson(EstrategiaVentasImageData? data) =>
    json.encode(data!.toJson());

class EstrategiaVentasImageData {
  const EstrategiaVentasImageData({
    this.id,
    this.image_name,
    this.estrategia_id,
  });

  final int? id;
  final String? image_name;
  final int? estrategia_id;

  factory EstrategiaVentasImageData.fromJson(Map<String, dynamic> json) =>
      EstrategiaVentasImageData(
          id: int.tryParse(json['id'].toString()) ?? 0,
          image_name: json['image_name'] as String?,
          estrategia_id: int.tryParse(json['estrategia_id'].toString()) ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_name": image_name,
        "estrategia_id": estrategia_id,
      };
}
