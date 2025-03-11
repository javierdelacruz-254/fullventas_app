import 'dart:convert';
import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/calificacion_instructor_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/calificacion_instructor_data_repo.dart';
import 'package:http/http.dart' as http;

class CalificacionInstructorDataApi extends CalificacionInstructorDataRepo {
  final String baseUrl = AppRoutes.postCalificacion;

  @override
  Future<void> saveCalificacion(CalificacionInstructorData calificacion) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(calificacion.toJson()),
      );
      print("📩 Enviando: ${json.encode(calificacion.toJson())}");
      print("📬 Respuesta del servidor: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Error al guardar la calificacion: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en la peticion: $e");
    }
  }
}
