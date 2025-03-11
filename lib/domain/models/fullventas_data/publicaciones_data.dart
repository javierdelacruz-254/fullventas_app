import 'dart:convert';

List<PublicacionesData> publicacionesDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => PublicacionesData.fromJson(item)).toList();
}

String publicacionesDataToJson(PublicacionesData? data) =>
    json.encode(data!.toJson());

class PublicacionesData {
  const PublicacionesData({
    this.id,
    this.userId,
    this.titulo,
    this.imagen,
    this.categoria,
    this.fechaCreacion,
    this.estado,
    this.tipoSeccion,
    this.resumen,
    this.linkVideo,
    this.subtitulo1,
    this.descripcion1,
    this.adjunto11Imagen,
    this.adjunto11Video,
    this.adjunto12Imagen,
    this.adjunto12Video,
    this.subtitulo2,
    this.descripcion2,
    this.adjunto21Imagen,
    this.adjunto21Video,
    this.adjunto22Imagen,
    this.adjunto22Video,
    this.tipoAdjunto11,
    this.tipoAdjunto21,
    this.tipoAdjunto12,
    this.tipoAdjunto22,
    this.subtitulo3,
    this.descripcion3,
    this.tipoAdjunto31,
    this.adjunto31Imagen,
    this.adjunto31Video,
    this.tipoAdjunto32,
    this.adjunto32Imagen,
    this.adjunto32Video,
  });
  final int? id;
  final int? userId;
  final String? titulo;
  final String? imagen;
  final String? categoria;
  final DateTime? fechaCreacion;
  final String? estado;
  final String? tipoSeccion;
  final String? resumen;
  final String? linkVideo;
  final String? subtitulo1;
  final String? descripcion1;
  final String? adjunto11Imagen;
  final String? adjunto11Video;
  final String? adjunto12Imagen;
  final String? adjunto12Video;
  final String? subtitulo2;
  final String? descripcion2;
  final String? adjunto21Imagen;
  final String? adjunto21Video;
  final String? adjunto22Imagen;
  final String? adjunto22Video;
  final String? tipoAdjunto11;
  final String? tipoAdjunto21;
  final String? tipoAdjunto12;
  final String? tipoAdjunto22;
  final String? subtitulo3;
  final String? descripcion3;
  final String? tipoAdjunto31;
  final String? adjunto31Imagen;
  final String? adjunto31Video;
  final String? tipoAdjunto32;
  final String? adjunto32Imagen;
  final String? adjunto32Video;

  factory PublicacionesData.fromJson(Map<String, dynamic> json) =>
      PublicacionesData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        titulo: json['titulo'] as String?,
        imagen: json['imagen'] as String?,
        categoria: json['categoria'] as String?,
        fechaCreacion: json['fecha_creacion'] != null
            ? DateTime.tryParse(json['fecha_creacion'])
            : null,
        estado: json['estado'] as String?,
        tipoSeccion: json['tipo_seccion'] as String?,
        resumen: json['resumen'] as String?,
        linkVideo: json['link_video'] as String?,
        subtitulo1: json['subtitulo1'] as String?,
        descripcion1: json['descripcion1'] as String?,
        adjunto11Imagen: json['adjunto1_1_imagen'] as String?,
        adjunto11Video: json['adjunto1_1_video'] as String?,
        adjunto12Imagen: json['adjunto1_2_imagen'] as String?,
        adjunto12Video: json['adjunto1_2_video'] as String?,
        subtitulo2: json['subtitulo2'] as String?,
        descripcion2: json['descripcion2'] as String?,
        adjunto21Imagen: json['adjunto2_1_imagen'] as String?,
        adjunto21Video: json['adjunto2_1_video'] as String?,
        adjunto22Imagen: json['adjunto2_2_imagen'] as String?,
        adjunto22Video: json['adjunto2_2_video'] as String?,
        tipoAdjunto11: json['tipo_adjunto1_1'] as String?,
        tipoAdjunto21: json['tipo_adjunto2_1'] as String?,
        tipoAdjunto12: json['tipo_adjunto1_2'] as String?,
        tipoAdjunto22: json['tipo_adjunto2_2'] as String?,
        subtitulo3: json['subtitulo3'] as String?,
        descripcion3: json['descripcion3'] as String?,
        tipoAdjunto31: json['tipo_adjunto3_1'] as String?,
        adjunto31Imagen: json['adjunto3_1_imagen'] as String?,
        adjunto31Video: json['adjunto3_1_video'] as String?,
        tipoAdjunto32: json['tipo_adjunto3_2'] as String?,
        adjunto32Imagen: json['adjunto3_2_imagen'] as String?,
        adjunto32Video: json['adjunto3_2_video'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "titulo": titulo,
        "imagen": imagen,
        "categoria": categoria,
        "fecha_creacion": fechaCreacion,
        "estado": estado,
        "tipo_seccion": tipoSeccion,
        "resumen": resumen,
        "link_video": linkVideo,
        "subtitulo1": subtitulo1,
        "descripcion1": descripcion1,
        "adjunto1_1_imagen": adjunto11Imagen,
        "adjunto1_1_video": adjunto11Video,
        "adjunto1_2_imagen": adjunto12Imagen,
        "adjunto1_2_video": adjunto12Video,
        "subtitulo2": subtitulo2,
        "descripcion2": descripcion2,
        "adjunto2_1_imagen": adjunto21Imagen,
        "adjunto2_1_video": adjunto21Video,
        "adjunto2_2_imagen": adjunto22Imagen,
        "adjunto2_2_video": adjunto22Video,
        "tipo_adjunto1_1": tipoAdjunto11,
        "tipo_adjunto2_1": tipoAdjunto21,
        "tipo_adjunto1_2": tipoAdjunto12,
        "tipo_adjunto2_2": tipoAdjunto22,
        "subtitulo3": subtitulo3,
        "descripcion3": descripcion3,
        "tipo_adjunto3_1": tipoAdjunto31,
        "adjunto3_1_imagen": adjunto31Imagen,
        "adjunto3_1_video": adjunto31Video,
        "tipo_adjunto3_2": tipoAdjunto32,
        "adjunto3_2_imagen": adjunto32Imagen,
        "adjunto3_2_video": adjunto32Video,
      };
}
