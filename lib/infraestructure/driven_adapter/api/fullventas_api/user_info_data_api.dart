import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/user_info_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_info_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class UserInfoDataApi extends UserInfoDataRepo {
  @override
  Future<List<UserInfoData>> getUserInfoDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getUserInfo);
    if (response.statusCode == 200) {
      final userInfoData = userInfoDataFromJson(response.body);
      return userInfoData;
    } else {
      throw UserInfoDataApiError(
          'Error al obtener los datos. Código de estado ${response.body}');
    }
  }
}
