import 'dart:convert';

List<SucursalesData> sucursalesDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => SucursalesData.fromJson(item)).toList();
}

String sucursalesDataToJson(SucursalesData? data) =>
    json.encode(data!.toJson());

class SucursalesData {
  const SucursalesData({
    this.id,
    this.user_id,
    this.nombre,
    this.distrito,
    this.direccion,
    this.numero_sucursal,
    this.correo,
    this.celular,
    this.horario,
    this.latitud,
    this.longitud,
    this.status,
    this.id_manager,
  });

  final int? id;
  final int? user_id;
  final String? nombre;
  final String? distrito;
  final String? direccion;
  final String? numero_sucursal;
  final String? correo;
  final String? celular;
  final String? horario;
  final String? latitud;
  final String? longitud;
  final int? status;
  final int? id_manager;

  factory SucursalesData.fromJson(Map<String, dynamic> json) => SucursalesData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
        nombre: json['nombre'] as String?,
        distrito: json['distrito'] as String?,
        direccion: json['direccion'] as String?,
        numero_sucursal: json['numero_sucursal'] as String?,
        correo: json['correo'] as String?,
        celular: json['celular'] as String?,
        horario: json['horario'] as String?,
        latitud: json['latitud'] as String?,
        longitud: json['longitud'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
        id_manager: int.tryParse(json['id_manager'].toString()) ?? 0,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "nombre": nombre,
        "distrito": distrito,
        "direccion": direccion,
        "numero_sucursal": numero_sucursal,
        "correo": correo,
        "celular": celular,
        "horario": horario,
        "latitud": latitud,
        "longitud": longitud,
        "status": status,
        "id_manager": id_manager,
      };
}
