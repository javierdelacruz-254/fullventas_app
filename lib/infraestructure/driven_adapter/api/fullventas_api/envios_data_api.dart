import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/envios_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/envios_data_repo.dart';
import 'package:http/http.dart' as http;

class EnviosDataApi extends EnviosDataRepo {
  @override
  Future<List<EnviosData>> getEnviosById(int sucursalId) async {
    final response = await http.get(Uri.parse(AppRoutes.getEnvios(sucursalId)));
    if (response.statusCode == 200) {
      final enviosData = enviosDataFromJson(response.body);
      print(response.body);
      return enviosData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.body}');
    }
  }
}
