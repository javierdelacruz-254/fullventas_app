import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/login_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/login_data_api.dart';

final loginDataProvider = Provider<LoginDetailUseCase>((ref) {
  return LoginDetailUseCase(LoginDataApi());
});
