import 'dart:convert';

List<PlanesImageData> planesImageDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => PlanesImageData.fromJson(item)).toList();
}

String planesImageDataToJson(PlanesImageData? data) =>
    json.encode(data!.toJson());

class PlanesImageData {
  const PlanesImageData({
    this.id,
    this.image_name,
    this.plan_id,
  });

  final int? id;
  final String? image_name;
  final int? plan_id;

  factory PlanesImageData.fromJson(Map<String, dynamic> json) =>
      PlanesImageData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        image_name: json['image_name'] as String?,
        plan_id: int.tryParse(json['plan_id'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_name": image_name,
        "plan_id": plan_id,
      };
}
