import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/pases_libre_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class PasesLibreDataApi extends PasesLibreDataRepo {
  @override
  Future<List<PasesLibreData>> getPasesLibresDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getPaseLibre);
    if (response.statusCode == 200) {
      final paseslibreData = paseslibresDataFromJson(response.body);
      return paseslibreData;
    } else {
      throw PasesLibreDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
