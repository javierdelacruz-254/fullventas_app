import 'dart:convert';

List<RutinasData> rutinasDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => RutinasData.fromJson(item)).toList();
}

String rutinasDataToJson(RutinasData? data) => json.encode(data!.toJson());

class RutinasData {
  const RutinasData({
    this.idRutina,
    this.nombre,
    this.frecuencia,
    this.fechaInicio,
    this.fechaFin,
    this.idCliente,
    this.idInstructor,
    this.tipoRutina,
    this.descripcion,
    this.objetivos,
    this.metas,
    this.imagen1,
    this.imagen2,
    this.registroRutina,
    this.nombreCliente,
    this.nombreInstructor,
  });

  final int? idRutina;
  final String? nombre;
  final String? frecuencia;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? idCliente;
  final int? idInstructor;
  final String? tipoRutina;
  final String? descripcion;
  final String? objetivos;
  final String? metas;
  final String? imagen1;
  final String? imagen2;
  final String? registroRutina;
  final String? nombreCliente;
  final String? nombreInstructor;

  factory RutinasData.fromJson(Map<String, dynamic> json) => RutinasData(
        idRutina: int.tryParse(json['id_rutina'].toString()) ?? 0,
        nombre: json['nombre'] as String?,
        frecuencia: json['frecuencia'] as String?,
        fechaInicio: json['fecha_inicio'] != null
            ? DateTime.tryParse(json['fecha_inicio'])
            : null,
        fechaFin: json['fecha_fin'] != null
            ? DateTime.tryParse(json['fecha_fin'])
            : null,
        idCliente: int.tryParse(json['id_cliente'].toString()) ?? 0,
        idInstructor: int.tryParse(json['id_instructor'].toString()) ?? 0,
        tipoRutina: json['tipo_rutina'] as String?,
        descripcion: json['descripcion'] as String?,
        objetivos: json['objetivos'] as String?,
        metas: json['metas'] as String?,
        imagen1: json['imagen1'] as String?,
        imagen2: json['imagen2'] as String?,
        registroRutina: json['registro_rutina'] as String?,
        nombreCliente: json['nombre_cliente'] as String?,
        nombreInstructor: json['nombre_instructor'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id_rutina": idRutina,
        "nombre": nombre,
        "frecuencia": frecuencia,
        "fecha_inicio": fechaInicio?.toIso8601String().split("T")[0],
        "fecha_fin": fechaFin?.toIso8601String().split("T")[0],
        "id_cliente": idCliente,
        "id_instructor": idInstructor,
        "tipo_rutina": tipoRutina,
        "descripcion": descripcion,
        "objetivos": objetivos,
        "metas": metas,
        "imagen1": imagen1,
        "imagen2": imagen2,
        "registro_rutina": registroRutina,
        "nombre_cliente": nombreCliente,
        "nombre_instructor": nombreInstructor,
      };
}
