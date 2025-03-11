import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/disciplinas_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/disciplinas_data_api.dart';

final disciplinasDataProvider = Provider<DisciplinasDetailUseCase>(
  (ref) {
    return DisciplinasDetailUseCase(DisciplinasDataApi());
  },
);
