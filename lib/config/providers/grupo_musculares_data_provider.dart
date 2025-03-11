import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/grupo_musculares_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/grupo_musculares_data_api.dart';

final grupoMuscularesDataProvider = Provider<GrupoMuscularesDetailUseCase>(
  (ref) {
    return GrupoMuscularesDetailUseCase(GrupoMuscularesDataApi());
  },
);
