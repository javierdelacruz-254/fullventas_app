import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/destination_type_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/destination_type_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class DestinationTypeDataApi extends DestinationTypeDataRepo {
  @override
  Future<List<DestinationTypeData>> getDestinationType() async {
    final response = await HttpHelperGet.get(AppRoutes.getDestinaton);
    if (response.statusCode == 200) {
      final destinationTypeData = destinationTypeDataFromJson(response.body);
      return destinationTypeData;
    } else {
      throw DestinationTypeDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
