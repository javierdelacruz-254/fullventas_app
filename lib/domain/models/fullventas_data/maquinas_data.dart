import 'dart:convert';

List<MaquinasData> maquinaGymDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => MaquinasData.fromJson(item)).toList();
}

String maquinaGymDataToJson(MaquinasData? data) => json.encode(data!.toJson());

class MaquinasData {
  const MaquinasData({
    this.idMaquina,
    this.nombreMaquina,
    this.descripcion,
    this.foto1,
    this.foto2,
    this.idMusculo,
    this.estado,
    this.idGrupo,
    this.userId,
    this.nombre_musculo,
  });

  final int? idMaquina;
  final String? nombreMaquina;
  final String? descripcion;
  final String? foto1;
  final String? foto2;
  final int? idMusculo;
  final String? estado; // Activo | Inactivo
  final int? idGrupo;
  final int? userId;
  final String? nombre_musculo;

  factory MaquinasData.fromJson(Map<String, dynamic> json) => MaquinasData(
        idMaquina: int.tryParse(json['id_maquina'].toString()) ?? 0,
        nombreMaquina: json['nombre_maquina'] as String?,
        descripcion: json['descripcion'] as String?,
        foto1: json['foto_1'] as String?,
        foto2: json['foto_2'] as String?,
        idMusculo: int.tryParse(json['id_musculo'].toString()) ?? 0,
        estado: json['estado'] as String?,
        idGrupo: int.tryParse(json['id_grupo'].toString()) ?? 0,
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        nombre_musculo: json['nombre_musculo'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id_maquina": idMaquina,
        "nombre_maquina": nombreMaquina,
        "descripcion": descripcion,
        "foto_1": foto1,
        "foto_2": foto2,
        "id_musculo": idMusculo,
        "estado": estado,
        "id_grupo": idGrupo,
        "user_id": userId,
        "nombre_musculo": nombre_musculo,
      };
}
