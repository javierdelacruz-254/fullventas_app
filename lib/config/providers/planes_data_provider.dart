import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/planes_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/planes_data_api.dart';

final searchQueryPlanes = StateProvider<String>((ref) => '');

final planesDataProvider = Provider<PlanesDetailUseCase>(
  (ref) {
    return PlanesDetailUseCase(PlanesDataApi());
  },
);
