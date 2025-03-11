import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/sugerencias_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/sugerencias_data_api.dart';

final sugerenciasDataProvider = Provider<SugerenciasDetailUseCase>(
  (ref) {
    return SugerenciasDetailUseCase(SugerenciasDataApi());
  },
);
