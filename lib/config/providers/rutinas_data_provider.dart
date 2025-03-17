import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/rutinas_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/rutinas_data_api.dart';

final rutinasDataProvider = Provider<RutinasDetailUseCase>(
  (ref) {
    return RutinasDetailUseCase(RutinasDataApi());
  },
);
