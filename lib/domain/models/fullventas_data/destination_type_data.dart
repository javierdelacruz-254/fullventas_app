import 'dart:convert';

List<DestinationTypeData> destinationTypeDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => DestinationTypeData.fromJson(item)).toList();
}

String destinationTypeDataToJson(DestinationTypeData? data) =>
    json.encode(data!.toJson());

class DestinationTypeData {
  const DestinationTypeData({
    this.id,
    this.description,
  });

  final int? id;
  final String? description;

  factory DestinationTypeData.fromJson(Map<String, dynamic> json) =>
      DestinationTypeData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
