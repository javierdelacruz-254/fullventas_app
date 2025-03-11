import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/user_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/user_data_api.dart';

final userDataProvider = Provider<UserDetailUseCase>(
  (ref) {
    return UserDetailUseCase(UserDataApi());
  },
);
