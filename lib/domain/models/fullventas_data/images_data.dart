import 'dart:convert';

List<ImageData> imageDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => ImageData.fromJson(item)).toList();
}

String imageDataToJson(ImageData? data) => json.encode(data!.toJson());

class ImageData {
  const ImageData({
    this.id,
    this.image_name,
    this.color_id,
    this.product_id,
  });

  final int? id;
  final String? image_name;
  final int? color_id;
  final int? product_id;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        image_name: json['image_name'] as String?,
        color_id: int.tryParse(json['color_id'].toString()) ?? 0,
        product_id: int.tryParse(json['product_id'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_name": image_name,
        "color_id": color_id,
        "product_id": product_id,
      };
}
