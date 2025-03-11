import 'dart:convert';

List<InstructorData> instructorDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => InstructorData.fromJson(item)).toList();
}

String instructorDataToJson(InstructorData? data) =>
    json.encode(data!.toJson());

class InstructorData {
  const InstructorData({
    this.idInstructor,
    this.nombre,
    this.apellido,
    this.correo,
    this.telefono,
    this.direccion,
    this.edad,
    this.genero,
    this.imagen,
    this.aniosExperiencia,
    this.userId,
    this.password,
    this.idEspecialidad,
  });

  final int? idInstructor;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String? telefono;
  final String? direccion;
  final int? edad;
  final String? genero;
  final String? imagen;
  final int? aniosExperiencia;
  final int? userId;
  final String? password;
  final int? idEspecialidad;

  factory InstructorData.fromJson(Map<String, dynamic> json) => InstructorData(
        idInstructor: int.tryParse(json['id_instructor'].toString()) ?? 0,
        nombre: json['nombre'] as String?,
        apellido: json['apellido'] as String?,
        correo: json['correo'] as String?,
        telefono: json['telefono'] as String?,
        direccion: json['direccion'] as String?,
        edad: int.tryParse(json['edad'].toString()) ?? 0,
        genero: json['genero'] as String?,
        imagen: json['imagen'] as String?,
        aniosExperiencia:
            int.tryParse(json['anios_experiencia'].toString()) ?? 0,
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        password: json['password'] as String?,
        idEspecialidad: int.tryParse(json['ID_Especialidad'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id_instructor": idInstructor,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "telefono": telefono,
        "direccion": direccion,
        "edad": edad,
        "genero": genero,
        "imagen": imagen,
        "anios_experiencia": aniosExperiencia,
        "user_id": userId,
        "password": password,
        "ID_Especialidad": idEspecialidad,
      };
}
