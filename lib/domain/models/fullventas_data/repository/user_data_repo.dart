import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';

abstract class UserDataRepo {
  Future<List<UserData>> getUserDataRepo();
}
