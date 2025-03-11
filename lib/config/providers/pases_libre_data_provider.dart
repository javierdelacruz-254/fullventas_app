import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/pases_libre_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/pases_libre_data_api.dart';

final paseslibreDataProvider = Provider<PasesLibreDetailUseCase>(
  (ref) {
    return PasesLibreDetailUseCase(PasesLibreDataApi());
  },
);
