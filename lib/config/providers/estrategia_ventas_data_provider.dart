import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/estrategia_ventas_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/estrategia_ventas_data_api.dart';

final searchQueryEstrategia = StateProvider<String>((ref) => '');

final estrategiaVentasDataProvider = Provider<EstrategiaVentasDetailUseCase>(
  (ref) {
    return EstrategiaVentasDetailUseCase(EstrategiaVentasDataApi());
  },
);
