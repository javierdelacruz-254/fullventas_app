import 'dart:convert';
import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/reclamo_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/reclamo_data_repo.dart';
import 'package:http/http.dart' as http;

class ReclamoDataApi extends ReclamoDataRepo {
  final String baseUrl = AppRoutes.postReclamo;
  @override
  Future<void> saveReclamo(ReclamoData reclamo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(reclamo.toJson()),
      );
      print("📩 Enviando: ${json.encode(reclamo.toJson())}");
      print("📬 Respuesta del servidor: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Error al guardar la calificacion: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en la peticion: $e");
    }
  }
}
