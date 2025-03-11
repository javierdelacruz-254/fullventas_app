import 'dart:convert';
import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/sugerencias_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_data.dart';
import 'package:http/http.dart' as http;

class SugerenciasDataApi extends SugerenciasDataRepo {
  final String baseUrl = AppRoutes.insertSugerencias;
  @override
  Future<void> saveSugerencia(SugerenciasData sugerencia) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(sugerencia.toJson()),
      );
      print("📩 Enviando: ${json.encode(sugerencia.toJson())}");
      print("📬 Respuesta del servidor: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Error al guardar sugerencia: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en la peticion: $e");
    }
  }
}
