import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/publicaciones_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/publicaciones_data_api.dart';

final publicacionesDataProvider = Provider<PublicacionesDetailUseCase>(
  (ref) {
    return PublicacionesDetailUseCase(PublicacionesDataApi());
  },
);
