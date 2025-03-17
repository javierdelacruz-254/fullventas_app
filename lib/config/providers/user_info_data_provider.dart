import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/user_info_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/user_info_data_api.dart';

final userInfoDataProvider = Provider<UserInfoDetailUseCase>(
  (ref) {
    return UserInfoDetailUseCase(UserInfoDataApi());
  },
);
