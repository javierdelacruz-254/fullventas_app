import 'dart:convert';

List<ServicesData> servicesDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => ServicesData.fromJson(item)).toList();
}

String servicesDataToJson(ServicesData? data) => json.encode(data!.toJson());

class ServicesData {
  const ServicesData({
    this.id,
    this.title,
    this.category,
    this.description,
    this.marca,
    this.linkVideoOne,
    this.linkVideoTwo,
    this.purchasePrice,
    this.price,
    this.descuento,
    this.previousPrice,
    this.date,
    this.sort,
    this.imageName,
    this.userId,
    this.weight,
    this.longs,
    this.longSleeve,
    this.backWidth,
    this.breastContour,
    this.waist,
    this.hip,
    this.status,
    this.relevant,
    this.additional,
    this.brand,
    this.qty,
    this.outstanding,
    this.fotosTalla,
    this.palabrasClaves,
    this.tipoProducto,
    this.fechaInicio,
    this.fechaFin,
    this.promocion,
    this.idProductSize,
    this.horario,
    this.horarioFoto,
    this.profesor,
    this.profesorFoto,
  });

  final int? id;
  final String? title;
  final int? category;
  final String? description;
  final String? marca;
  final String? linkVideoOne;
  final String? linkVideoTwo;
  final double? purchasePrice;
  final double? price;
  final double? descuento;
  final double? previousPrice;
  final String? date;
  final int? sort;
  final String? imageName;
  final int? userId;
  final String? weight;
  final String? longs;
  final String? longSleeve;
  final String? backWidth;
  final String? breastContour;
  final String? waist;
  final String? hip;
  final int? status;
  final int? relevant;
  final String? additional;
  final String? brand;
  final int? qty;
  final int? outstanding;
  final String? fotosTalla;
  final String? palabrasClaves;
  final int? tipoProducto;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? promocion;
  final int? idProductSize;
  final String? horario;
  final String? horarioFoto;
  final String? profesor;
  final String? profesorFoto;

  factory ServicesData.fromJson(Map<String, dynamic> json) => ServicesData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        title: json['title'] as String?,
        category: int.tryParse(json['category'].toString()) ?? 0,
        description: json['description'] as String?,
        marca: json['marca'] as String?,
        linkVideoOne: json['link_video_one'] as String?,
        linkVideoTwo: json['link_video_two'] as String?,
        purchasePrice:
            double.tryParse(json['purchase_price'].toString()) ?? 0.0,
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        descuento: double.tryParse(json['descuento'].toString()) ?? 0.0,
        previousPrice:
            double.tryParse(json['previous_price'].toString()) ?? 0.0,
        date: json['date'] as String?,
        sort: int.tryParse(json['sort'].toString()) ?? 0,
        imageName: json['image_name'] as String?,
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        weight: json['weight'] as String?,
        longs: json['longs'] as String?,
        longSleeve: json['long_sleeve'] as String?,
        backWidth: json['back_width'] as String?,
        breastContour: json['breast_contour'] as String?,
        waist: json['waist'] as String?,
        hip: json['hip'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
        relevant: int.tryParse(json['relevant'].toString()) ?? 0,
        additional: json['additional'] as String?,
        brand: json['brand'] as String?,
        qty: int.tryParse(json['qty'].toString()) ?? 0,
        outstanding: int.tryParse(json['outstanding'].toString()) ?? 0,
        fotosTalla: json['fotos_talla'] as String?,
        palabrasClaves: json['palabras_claves'] as String?,
        tipoProducto: int.tryParse(json['tipo_producto'].toString()) ?? 0,
        fechaInicio: json['fecha_inicio'] != null
            ? DateTime.tryParse(json['fecha_inicio'])
            : null,
        fechaFin: json['fecha_fin'] != null
            ? DateTime.tryParse(json['fecha_fin'])
            : null,
        promocion: int.tryParse(json['promocion'].toString()) ?? 0,
        idProductSize: int.tryParse(json['id_product_size'].toString()) ?? 0,
        horario: json['horario'] as String?,
        horarioFoto: json['horario_foto'] as String?,
        profesor: json['profesor'] as String?,
        profesorFoto: json['profesor_foto'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "description": description,
        "marca": marca,
        "link_video_one": linkVideoOne,
        "link_video_two": linkVideoTwo,
        "purchase_price": purchasePrice,
        "price": price,
        "descuento": descuento,
        "previous_price": previousPrice,
        "date": date,
        "sort": sort,
        "image_name": imageName,
        "user_id": userId,
        "weight": weight,
        "longs": longs,
        "long_sleeve": longSleeve,
        "back_width": backWidth,
        "breast_contour": breastContour,
        "waist": waist,
        "hip": hip,
        "status": status,
        "relevant": relevant,
        "additional": additional,
        "brand": brand,
        "qty": qty,
        "outstanding": outstanding,
        "fotos_talla": fotosTalla,
        "palabras_claves": palabrasClaves,
        "tipo_producto": tipoProducto,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "promocion": promocion,
        "id_product_size": idProductSize,
        "horario": horario,
        "horario_foto": horarioFoto,
        "profesor": profesor,
        "profesor_foto": profesorFoto,
      };
}
