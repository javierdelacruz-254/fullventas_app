import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/estrategia_ventas_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class EstrategiaVentasDataApi extends EstrategiaVentasDataRepo {
  @override
  Future<List<EstrategiaVentasData>> getEstrategiaVentasDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getEstrategia);
    if (response.statusCode == 200) {
      final estrategiaVentasData = estrategiaVentasDataFromJson(response.body);
      return estrategiaVentasData;
    } else {
      throw EstrategiaVentasDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
