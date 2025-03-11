import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/descuentos_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/descuentos_data_api.dart';

final descuentosDataProvider = Provider<DescuentosDetailUseCase>(
  (ref) {
    return DescuentosDetailUseCase(DescuentosDataApi());
  },
);
