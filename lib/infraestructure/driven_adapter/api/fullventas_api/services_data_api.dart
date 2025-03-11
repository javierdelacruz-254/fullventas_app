import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/services_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class ServicesDataApi extends ServicesDataRepo {
  @override
  Future<List<ServicesData>> getServicesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getServices);
    if (response.statusCode == 200) {
      final servicesData = servicesDataFromJson(response.body);
      return servicesData;
    } else {
      throw ServicesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
