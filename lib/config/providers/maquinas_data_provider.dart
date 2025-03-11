import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/maquinas_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/maquinas_data_api.dart';

final maquinasDataProvider = Provider<MaquinasDetailUseCase>(
  (ref) {
    return MaquinasDetailUseCase(MaquinasDataApi());
  },
);
