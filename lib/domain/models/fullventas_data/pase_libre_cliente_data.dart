import 'dart:convert';

List<PaseLibreClienteData> paseLibreClienteDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => PaseLibreClienteData.fromJson(item)).toList();
}

String paseLibreClienteDataToJson(PaseLibreClienteData? data) =>
    json.encode(data!.toJson());

class PaseLibreClienteData {
  const PaseLibreClienteData({
    this.idCliente,
    this.fecha,
    this.numpase,
    this.nombre,
    this.edad,
    this.whatsapp,
    this.estado,
    this.fechaIni,
    this.fechaFin,
    this.nombrePase,
    this.idPase,
  });

  final int? idCliente;
  final DateTime? fecha;
  final String? numpase;
  final String? nombre;
  final int? edad;
  final String? whatsapp;
  final String? estado;
  final String? fechaIni;
  final String? fechaFin;
  final String? nombrePase;
  final int? idPase;
  factory PaseLibreClienteData.fromJson(Map<String, dynamic> json) =>
      PaseLibreClienteData(
        idCliente: int.tryParse(json['idCliente'].toString()) ?? 0,
        fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
        numpase: json['numpase'] as String?,
        nombre: json['nombre'] as String?,
        edad: int.tryParse(json['edad'].toString()) ?? 0,
        whatsapp: json['whatsapp'] as String?,
        estado: json['estado'] as String?,
        fechaIni: json['fechaIni'] as String?,
        fechaFin: json['fechaFin'] as String?,
        nombrePase: json['NombrePase'] as String?,
        idPase: int.tryParse(json['idPase'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "fecha": fecha?.toIso8601String(),
        "numpase": numpase,
        "nombre": nombre,
        "edad": edad,
        "whatsapp": whatsapp,
        "estado": estado,
        "fechaIni": fechaIni,
        "fechaFin": fechaFin,
        "NombrePase": nombrePase,
        "idPase": idPase,
      };
}
