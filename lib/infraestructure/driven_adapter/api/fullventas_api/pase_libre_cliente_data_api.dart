import 'dart:convert';
import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pase_libre_cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/pase_libre_cliente_data_repo.dart';
import 'package:http/http.dart' as http;

class PaseLibreClienteDataApi extends PaseLibreClienteDataRepo {
  final String baseUrl = AppRoutes.postPaseLibreCliente;

  @override
  Future<void> savePaseLibreCliente(
      PaseLibreClienteData paseLibreCliente) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(paseLibreCliente.toJson()),
      );
      print("📩 Enviando: ${json.encode(paseLibreCliente.toJson())}");
      print("📬 Respuesta del servidor: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Error al guardar el pase libre: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en la peticion: $e");
    }
  }

  @override
  Future<List<PaseLibreClienteData>> getPaseLibreClienteById(
      String nombre) async {
    final response =
        await http.get(Uri.parse(AppRoutes.getPaseLibreCliente(nombre)));
    if (response.statusCode == 200) {
      final paseLibreClienteData = paseLibreClienteDataFromJson(response.body);
      print(response.body);
      return paseLibreClienteData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
