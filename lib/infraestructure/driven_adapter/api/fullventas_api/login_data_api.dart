import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/cliente_data_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginDataApi extends ClienteDataRepo {
  @override
  Future<ClienteData?> login(String codigo) async {
    try {
      final response =
          await http.post(Uri.parse(AppRoutes.login), body: {"codigo": codigo});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return ClienteData.fromJson(data['cliente']);
        } else {
          return null; // Cliente no encontrado
        }
      } else {
        throw Exception("Error al conectar con la API");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }
}
