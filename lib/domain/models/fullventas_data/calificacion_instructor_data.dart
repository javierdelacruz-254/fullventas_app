import 'dart:convert';

List<CalificacionInstructorData> calificacionInstructorDataFromJson(
    String str) {
  final jsonData = json.decode(str) as List;
  return jsonData
      .map((item) => CalificacionInstructorData.fromJson(item))
      .toList();
}

String calificacionInstructorDataToJson(CalificacionInstructorData? data) =>
    json.encode(data!.toJson());

class CalificacionInstructorData {
  const CalificacionInstructorData({
    this.ID_Calificacion_Instructor,
    this.ID_Instructor,
    this.ID_Detalle_Calificacion,
    this.Comentario,
    this.Fecha_Publicada,
    this.ID_Cliente,
    this.puntaje,
  });

  final int? ID_Calificacion_Instructor;
  final int? ID_Instructor;
  final int? ID_Detalle_Calificacion;
  final String? Comentario;
  final DateTime? Fecha_Publicada;
  final int? ID_Cliente;
  final int? puntaje;

  factory CalificacionInstructorData.fromJson(Map<String, dynamic> json) =>
      CalificacionInstructorData(
        ID_Calificacion_Instructor:
            int.tryParse(json['ID_Calificacion_Instructor'].toString()) ?? 0,
        ID_Instructor:
            int.tryParse(json['ID_Instructor_Detalle'].toString()) ?? 0,
        ID_Detalle_Calificacion:
            int.tryParse(json['ID_Detalle_Calificacion'].toString()) ?? 0,
        Comentario: json['Comentario'] as String?,
        Fecha_Publicada: json['Fecha_Publicada'] != null
            ? DateTime.tryParse(json['Fecha_Publicada'])
            : null,
        ID_Cliente: int.tryParse(json['ID_Cliente'].toString()) ?? 0,
        puntaje: int.tryParse(json['puntaje'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ID_Calificacion_Instructor": ID_Calificacion_Instructor,
        "ID_Instructor_Detalle": ID_Instructor,
        "ID_Detalle_Calificacion": ID_Detalle_Calificacion,
        "Comentario": Comentario,
        "Fecha_Publicada": Fecha_Publicada?.toIso8601String(),
        "ID_Cliente": ID_Cliente,
        "puntaje": puntaje,
      };
}
