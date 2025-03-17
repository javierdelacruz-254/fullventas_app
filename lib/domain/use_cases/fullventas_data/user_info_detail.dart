import 'package:fullventas_app/domain/models/fullventas_data/repository/user_info_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_info_data.dart';

class UserInfoDetailUseCase {
  final UserInfoDataRepo userInfoDataRepo;
  UserInfoDetailUseCase(this.userInfoDataRepo);
  Future<List<UserInfoData>> getUserInfoData() =>
      userInfoDataRepo.getUserInfoDataRepo();
}
