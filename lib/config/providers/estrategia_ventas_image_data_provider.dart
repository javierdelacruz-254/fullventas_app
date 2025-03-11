import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/estrategia_ventas_image_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/estrategia_ventas_image_data_api.dart';

final estrategiaVentasImageDataProvider =
    Provider<EstrategiaVentasImageDetailUseCase>(
  (ref) {
    return EstrategiaVentasImageDetailUseCase(EstrategiaVentasImageDataApi());
  },
);
