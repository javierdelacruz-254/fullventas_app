import 'dart:convert';

List<DisciplinasData> disciplinasDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => DisciplinasData.fromJson(item)).toList();
}

String disciplinasDataToJson(DisciplinasData? data) =>
    json.encode(data!.toJson());

class DisciplinasData {
  const DisciplinasData({
    this.ID_Especialidad,
    this.nombre,
  });

  final int? ID_Especialidad;
  final String? nombre;

  factory DisciplinasData.fromJson(Map<String, dynamic> json) =>
      DisciplinasData(
        ID_Especialidad: int.tryParse(json['ID_Especialidad'].toString()) ?? 0,
        nombre: json['nombre'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "ID_Especialidad": ID_Especialidad,
        "nombre": nombre,
      };
}
