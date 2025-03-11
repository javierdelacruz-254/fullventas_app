import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/sugerencias_type_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_type_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class SugerenciasTypeDataApi extends SugerenciasTypeDataRepo {
  @override
  Future<List<SugerenciasTypeData>> getSugerenciasTypeRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getSugerenciasType);
    if (response.statusCode == 200) {
      final sugerenciasTypeData = sugerenciasTypeDataFromJson(response.body);
      return sugerenciasTypeData;
    } else {
      throw SugerenciasTypeDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
