import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/pase_libre_cliente_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/pase_libre_cliente_data_api.dart';

final paseLibreClienteDataProvider = Provider<PaseLibreClienteDetailUseCase>(
  (ref) {
    return PaseLibreClienteDetailUseCase(PaseLibreClienteDataApi());
  },
);
