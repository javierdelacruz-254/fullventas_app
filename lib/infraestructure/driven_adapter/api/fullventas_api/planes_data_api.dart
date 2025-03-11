import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/planes_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/planes_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class PlanesDataApi extends PlanesDataRepo {
  @override
  Future<List<PlanesData>> getPlanesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getPlanes);
    if (response.statusCode == 200) {
      final planesData = planesDataFromJson(response.body);
      return planesData;
    } else {
      throw PlanesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
