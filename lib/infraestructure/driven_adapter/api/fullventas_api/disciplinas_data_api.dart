import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/disciplinas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/disciplinas_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class DisciplinasDataApi extends DisciplinasDataRepo {
  @override
  Future<List<DisciplinasData>> getDisciplinasDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getDisciplinas);
    if (response.statusCode == 200) {
      final disciplinasData = disciplinasDataFromJson(response.body);
      return disciplinasData;
    } else {
      throw DisciplinasDataApiError(
          'Error al obtener los datos. Códigos de estado ${response.statusCode}');
    }
  }
}
