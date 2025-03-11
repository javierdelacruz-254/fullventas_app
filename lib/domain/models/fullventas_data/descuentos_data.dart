import 'dart:convert';

List<DescuentosData> descuentosDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => DescuentosData.fromJson(item)).toList();
}

String descuentosDataToJson(DescuentosData? data) =>
    json.encode(data!.toJson());

class DescuentosData {
  const DescuentosData({
    this.id,
    this.user_id,
    this.title,
    this.category,
    this.tipo_producto,
    this.image_name,
    this.descripcion,
    this.marca,
    this.precio_descuento,
    this.precio_normal,
    this.porcentaje,
    this.id_product_size,
    this.qty,
    this.promocion,
    this.fecha_inicio,
    this.fecha_fin,
    this.horario,
    this.horario_foto,
    this.profesor,
    this.profesor_foto,
    this.link_video_one,
    this.link_video_two,
    this.status,
  });

  final int? id;
  final int? user_id;
  final String? title;
  final int? category;
  final int? tipo_producto;
  final String? image_name;
  final String? descripcion;
  final String? marca;
  final double? precio_descuento;
  final double? precio_normal;
  final double? porcentaje;
  final int? id_product_size;
  final int? qty;
  final int? promocion;
  final DateTime? fecha_inicio;
  final DateTime? fecha_fin;
  final String? horario;
  final String? horario_foto;
  final String? profesor;
  final String? profesor_foto;
  final String? link_video_one;
  final String? link_video_two;
  final int? status;

  factory DescuentosData.fromJson(Map<String, dynamic> json) => DescuentosData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
        title: json['title'] as String?,
        category: int.tryParse(json['category'].toString()) ?? 0,
        tipo_producto: int.tryParse(json['tipo_producto'].toString()) ?? 0,
        image_name: json['image_name'] as String?,
        descripcion: json['descripcion'] as String?,
        marca: json['marca'] as String?,
        precio_descuento:
            double.tryParse(json['precio_descuento'].toString()) ?? 0.0,
        precio_normal: double.tryParse(json['precio_normal'].toString()) ?? 0.0,
        porcentaje: double.tryParse(json['porcentaje'].toString()) ?? 0.0,
        id_product_size: int.tryParse(json['id_product_size'].toString()) ?? 0,
        qty: int.tryParse(json['qty'].toString()) ?? 0,
        promocion: int.tryParse(json['promocion'].toString()) ?? 0,
        fecha_inicio: json['fecha_inicio'] != null
            ? DateTime.tryParse(json['fecha_inicio'])
            : null,
        fecha_fin: json['fecha_fin'] != null
            ? DateTime.tryParse(json['fecha_fin'])
            : null,
        horario: json['horario'] as String?,
        horario_foto: json['horario_foto'] as String?,
        profesor: json['profesor'] as String?,
        profesor_foto: json['profesor_foto'] as String?,
        link_video_one: json['link_video_one'] as String?,
        link_video_two: json['link_video_two'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "title": title,
        "category": category,
        "tipo_producto": tipo_producto,
        "image_name": image_name,
        "descripcion": descripcion,
        "marca": marca,
        "precio_descuento": precio_descuento,
        "precio_normal": precio_normal,
        "porcentaje": porcentaje,
        "id_product_size": id_product_size,
        "qty": qty,
        "promocion": promocion,
        "fecha_inicio": fecha_inicio?.toIso8601String(),
        "fecha_fin": fecha_fin?.toIso8601String(),
        "horario": horario,
        "horario_foto": horario_foto,
        "profesor": profesor,
        "profesor_foto": profesor_foto,
        "link_video_one": link_video_one,
        "link_video_two": link_video_two,
        "status": status,
      };
}
