import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/sucursales_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class SucursalesDataApi extends SucursalesDataRepo {
  @override
  Future<List<SucursalesData>> getSucursalesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getSucursales);
    if (response.statusCode == 200) {
      final sucursalesData = sucursalesDataFromJson(response.body);
      return sucursalesData;
    } else {
      throw SucursalesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
