import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/grupo_musculares_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/grupo_musculares_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class GrupoMuscularesDataApi extends GrupoMuscularesDataRepo {
  @override
  Future<List<GrupoMuscularesData>> getGrupoMuscularesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getGrupoMusculares);
    if (response.statusCode == 200) {
      final grupoMuscularesData = grupoMuscularesDataFromJson(response.body);
      return grupoMuscularesData;
    } else {
      throw GrupoMuscularesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
