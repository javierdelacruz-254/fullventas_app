import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/planes_image_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/planes_image_data_api.dart';

final planesImageDataProvider = Provider<PlanesImageDetailUseCase>(
  (ref) {
    return PlanesImageDetailUseCase(PlanesImageDataApi());
  },
);
