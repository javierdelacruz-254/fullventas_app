import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/services_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/services_data_api.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final servicesDataProvider = Provider<ServicesDetailUseCase>(
  (ref) {
    return ServicesDetailUseCase(ServicesDataApi());
  },
);
