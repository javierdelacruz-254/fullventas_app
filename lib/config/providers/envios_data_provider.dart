import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/envios_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/envios_data_api.dart';

final enviosDataProvider = Provider<EnviosDetailUseCase>(
  (ref) {
    return EnviosDetailUseCase(EnviosDataApi());
  },
);
