import 'package:fullventas_app/domain/models/fullventas_data/user_info_data.dart';

abstract class UserInfoDataRepo {
  Future<List<UserInfoData>> getUserInfoDataRepo();
}
