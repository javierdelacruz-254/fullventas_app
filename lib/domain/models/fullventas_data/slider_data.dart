import 'dart:convert';

List<SliderData> sliderDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => SliderData.fromJson(item)).toList();
}

String sliderDataToJson(SliderData? data) => json.encode(data!.toJson());

class SliderData {
  const SliderData({
    this.id,
    this.id_user,
    this.title,
    this.description,
    this.date,
    this.sort,
    this.image_name,
    this.hip,
    this.status,
  });

  final int? id;
  final int? id_user;
  final String? title;
  final String? description;
  final DateTime? date;
  final int? sort;
  final String? image_name;
  final String? hip;
  final int? status;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        id_user: int.tryParse(json['id_user'].toString()) ?? 0,
        title: json['title'] as String?,
        description: json['description'] as String?,
        date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
        sort: int.tryParse(json['sort'].toString()) ?? 0,
        image_name: json['image_name'] as String?,
        hip: json['hip'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": id_user,
        "title": title,
        "description": description,
        "date": date?.toIso8601String(),
        "sort": sort,
        "image_name": image_name,
        "hip": hip,
        "status": status,
      };
}
