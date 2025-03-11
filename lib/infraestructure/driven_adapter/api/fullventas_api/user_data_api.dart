import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/user_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class UserDataApi extends UserDataRepo {
  @override
  Future<List<UserData>> getUserDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getUser);
    if (response.statusCode == 200) {
      final userData = userDataFromJson(response.body);
      return userData;
    } else {
      throw UserDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
