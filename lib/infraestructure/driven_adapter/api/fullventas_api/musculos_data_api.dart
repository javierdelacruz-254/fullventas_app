import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/musculos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/musculos_data_repo.dart';
import 'package:http/http.dart' as http;

class MusculosDataApi extends MusculosDataRepo {
  @override
  Future<List<MusculosData>> getMusculosById(int idGrupo) async {
    final response =
        await http.get(Uri.parse(AppRoutes.getMusculosById(idGrupo)));
    if (response.statusCode == 200) {
      final musculosData = musculosDataFromJson(response.body);
      print(response.body);
      return musculosData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
