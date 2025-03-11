import 'package:fullventas_app/domain/models/fullventas_data/repository/user_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';

class UserDetailUseCase {
  final UserDataRepo userDataRepo;
  UserDetailUseCase(this.userDataRepo);
  Future<List<UserData>> getUserData() => userDataRepo.getUserDataRepo();
}
