import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/descuentos_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class DescuentosDataApi extends DescuentosDataRepo {
  @override
  Future<List<DescuentosData>> getDescuentosDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getDescuentos);
    if (response.statusCode == 200) {
      final descuentosData = descuentosDataFromJson(response.body);
      return descuentosData;
    } else {
      throw DescuentosDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
