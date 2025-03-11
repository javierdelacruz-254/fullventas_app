import 'dart:convert';

List<ScreenData> screenDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData
      .map((item) => ScreenData.fromJson(item as Map<String, dynamic>))
      .toList();
}

String screenDataToJson(ScreenData? data) => json.encode(data!.toJson());

class ScreenData {
  const ScreenData({
    required this.id,
    required this.id_tienda,
    this.color,
    this.codigo,
    this.image_logo,
    this.image_icono,
    this.nombre,
    this.facebook_url,
    this.instagram_url,
    this.mision,
    this.vision,
    this.objetivos,
    this.nosotros,
    this.icono_cat_productos,
    this.icono_cat_servicios,
    this.icono_cat_membresias,
    this.icono_cat_ofertas_promociones,
    this.icono_cat_otros,
    this.div_cat_productos,
    this.div_cat_servicios,
    this.div_cat_membresias,
    this.div_cat_ofertas_promociones,
    this.div_cat_otros,
    this.url_video,
    this.color_texto,
    required this.estado,
  });

  final int? id;
  final int? id_tienda;
  final String? color;
  final String? codigo;
  final String? image_logo;
  final String? image_icono;
  final String? nombre;
  final String? facebook_url;
  final String? instagram_url;
  final String? mision;
  final String? vision;
  final String? objetivos;
  final String? nosotros;
  final String? icono_cat_productos;
  final String? icono_cat_servicios;
  final String? icono_cat_membresias;
  final String? icono_cat_ofertas_promociones;
  final String? icono_cat_otros;
  final String? div_cat_productos;
  final String? div_cat_servicios;
  final String? div_cat_membresias;
  final String? div_cat_ofertas_promociones;
  final String? div_cat_otros;
  final String? url_video;
  final String? color_texto;
  final int? estado;

  factory ScreenData.fromJson(Map<String, dynamic> json) => ScreenData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        id_tienda: int.tryParse(json['id_tienda'].toString()) ?? 0,
        color: json['color'] as String?,
        codigo: json['codigo'] as String?,
        image_logo: json['image_logo'] as String?,
        image_icono: json['image_icono'] as String?,
        nombre: json['nombre'] as String?,
        facebook_url: json['facebook_url'] as String?,
        instagram_url: json['instagram_url'] as String?,
        mision: json['mision'] as String?,
        vision: json['vision'] as String?,
        objetivos: json['objetivos'] as String?,
        nosotros: json['nosotros'] as String?,
        icono_cat_productos: json['icono_cat_productos'] as String?,
        icono_cat_servicios: json['icono_cat_servicios'] as String?,
        icono_cat_membresias: json['icono_cat_membresias'] as String?,
        icono_cat_ofertas_promociones:
            json['icono_cat_ofertas_promociones'] as String?,
        icono_cat_otros: json['icono_cat_otros'] as String?,
        div_cat_productos: json['div_cat_productos'] as String?,
        div_cat_servicios: json['div_cat_servicios'] as String?,
        div_cat_membresias: json['div_cat_membresias'] as String?,
        div_cat_ofertas_promociones:
            json['div_cat_ofertas_promociones'] as String?,
        div_cat_otros: json['div_cat_otros'] as String?,
        url_video: json['url_video'] as String?,
        color_texto: json['color_texto'] as String?,
        estado: int.tryParse(json['estado'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_tienda": id_tienda,
        "color": color,
        "codigo": codigo,
        "image_logo": image_logo,
        "image_icono": image_icono,
        "nombre": nombre,
        "facebook_url": facebook_url,
        "instagram_url": instagram_url,
        "mision": mision,
        "vision": vision,
        "objetivos": objetivos,
        "nosotros": nosotros,
        "icono_cat_productos": icono_cat_productos,
        "icono_cat_servicios": icono_cat_servicios,
        "icono_cat_membresias": icono_cat_membresias,
        "icono_cat_ofertas_promociones": icono_cat_ofertas_promociones,
        "icono_cat_otros": icono_cat_otros,
        "div_cat_productos": div_cat_productos,
        "div_cat_servicios": div_cat_servicios,
        "div_cat_membresias": div_cat_membresias,
        "div_cat_ofertas_promociones": div_cat_ofertas_promociones,
        "div_cat_otros": div_cat_otros,
        "url_video": url_video,
        "color_texto": color_texto,
        "estado": estado?.toString(),
      };
}
