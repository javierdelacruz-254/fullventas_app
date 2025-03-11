import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/screen_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/screen_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class ScreenDataApi extends ScreenDataRepo {
  @override
  Future<List<ScreenData>> getScreenDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getScreen);
    if (response.statusCode == 200) {
      final screenData = screenDataFromJson(response.body);
      return screenData;
    } else {
      throw ScreenDataApiError(
          'Error al obtener los datos. Código de estado: ${response.statusCode}');
    }
  }
}
