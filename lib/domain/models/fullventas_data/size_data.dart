import 'dart:convert';

List<SizeData> sizeDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => SizeData.fromJson(item)).toList();
}

String sizeDataToJson(SizeData? data) => json.encode(data!.toJson());

class SizeData {
  const SizeData({
    this.size_id,
    this.size_name,
  });

  final int? size_id;
  final String? size_name;

  factory SizeData.fromJson(Map<String, dynamic> json) => SizeData(
        size_id: int.tryParse(json['size_id'].toString()) ?? 0,
        size_name: json['size_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "size_id": size_id,
        "size_name": size_name,
      };
}
