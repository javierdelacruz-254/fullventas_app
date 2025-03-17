import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/rutinas_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/rutinas_data.dart';
import 'package:http/http.dart' as http;

class RutinasDataApi extends RutinasDataRepo {
  @override
  Future<List<RutinasData>> getRutinasById(int idCliente) async {
    final response = await http.get(Uri.parse(AppRoutes.getRutinas(idCliente)));
    if (response.statusCode == 200) {
      final rutinasData = rutinasDataFromJson(response.body);
      print(response.body);
      return rutinasData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
