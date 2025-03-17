import 'dart:convert';

List<UbigeoData> ubigeoDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => UbigeoData.fromJson(item)).toList();
}

String ubigeoDatatoJson(UbigeoData? data) => json.encode(data!.toJson());

class UbigeoData {
  const UbigeoData({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory UbigeoData.fromJson(Map<String, dynamic> json) => UbigeoData(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
