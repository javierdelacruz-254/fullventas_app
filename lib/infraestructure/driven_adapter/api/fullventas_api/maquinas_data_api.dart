import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/maquinas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/maquinas_data_repo.dart';
import 'package:http/http.dart' as http;

class MaquinasDataApi extends MaquinasDataRepo {
  @override
  Future<List<MaquinasData>> getMaquinasById(int idGrupo) async {
    final response = await http.get(Uri.parse(AppRoutes.getMaquinas(idGrupo)));
    if (response.statusCode == 200) {
      final maquinasData = maquinaGymDataFromJson(response.body);
      print(response.body);
      return maquinasData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
