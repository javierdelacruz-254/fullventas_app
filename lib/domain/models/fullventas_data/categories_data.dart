import 'dart:convert';

List<CategoriesData> categoriesDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => CategoriesData.fromJson(item)).toList();
}

String categoriesDataToJson(CategoriesData? data) =>
    json.encode(data!.toJson());

class CategoriesData {
  const CategoriesData({
    this.id,
    this.title,
    this.alias,
    this.sort,
    this.image_name,
    this.id_rubro,
    this.id_user_store,
    this.types,
    this.status,
    this.tipo_tabla,
  });

  final int? id;
  final String? title;
  final String? alias;
  final int? sort;
  final String? image_name;
  final int? id_rubro;
  final int? id_user_store;
  final int? types;
  final int? status;
  final String? tipo_tabla;

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        title: json['title'] as String?,
        alias: json['alias'] as String?,
        sort: int.tryParse(json['sort'].toString()) ?? 0,
        image_name: json['image_name'] as String?,
        id_rubro: int.tryParse(json['id_rubro'].toString()) ?? 0,
        id_user_store: int.tryParse(json['id_user_store'].toString()) ?? 0,
        types: int.tryParse(json['types'].toString()) ?? 0,
        status: int.tryParse(json['status'].toString()) ?? 0,
        tipo_tabla: json['tipo_tabla'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "alias": alias,
        "sort": sort,
        "image_name": image_name,
        "id_rubro": id_rubro,
        "id_user_store": id_user_store,
        "types": types,
        "status": status,
        "tipo_tabla": tipo_tabla,
      };
}
