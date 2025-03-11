import 'dart:convert';

List<SugerenciasData> sugerenciasDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => SugerenciasData.fromJson(item)).toList();
}

String sugerenciasDataToJson(SugerenciasData? data) =>
    json.encode(data!.toJson());

class SugerenciasData {
  const SugerenciasData({
    this.subject,
    this.description,
    this.userId,
    this.localId,
    this.typeId,
    this.destinationId,
    this.image1Url,
    this.image2Url,
    this.date,
  });

  final String? subject;
  final String? description;
  final int? userId;
  final int? localId;
  final int? typeId;
  final int? destinationId;
  final String? image1Url;
  final String? image2Url;
  final DateTime? date;

  factory SugerenciasData.fromJson(Map<String, dynamic> json) =>
      SugerenciasData(
        subject: json['subject'] as String?,
        description: json['description'] as String?,
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        localId: int.tryParse(json['local_id'].toString()) ?? 0,
        typeId: int.tryParse(json['type_id'].toString()) ?? 0,
        destinationId: int.tryParse(json['destination_id'].toString()) ?? 0,
        image1Url: json['image1Url'] as String?,
        image2Url: json['image2Url'] as String?,
        date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "description": description,
        "user_id": userId,
        "local_id": localId,
        "type_id": typeId,
        "destination_id": destinationId,
        "image1Url": image1Url,
        "image2Url": image2Url,
        "date": date?.toIso8601String(),
      };
}
