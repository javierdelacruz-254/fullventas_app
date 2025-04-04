import 'dart:convert';

List<EnviosData> enviosDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => EnviosData.fromJson(item)).toList();
}

String enviosDataToJson(EnviosData? data) => json.encode(data!.toJson());

class EnviosData {
  const EnviosData({
    this.id,
    this.user_id,
    this.sucursal_id,
    this.distrito,
    this.precio,
    this.status,
  });

  final int? id;
  final int? user_id;
  final int? sucursal_id;
  final String? distrito;
  final double? precio;
  final int? status;

  factory EnviosData.fromJson(Map<String, dynamic> json) => EnviosData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
        sucursal_id: int.tryParse(json['sucursal_id'].toString()) ?? 0,
        distrito: json['distrito'] as String?,
        precio: double.tryParse(json['precio'].toString()) ?? 0,
        status: int.tryParse(json['status'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "sucursal_id": sucursal_id,
        "distrito": distrito,
        "precio": precio,
        "status": status,
      };
}
