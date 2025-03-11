import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/sucursales_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/sucursales_data_api.dart';

final sucursalesDataProvider = Provider<SucursalesDetailUseCase>(
  (ref) {
    return SucursalesDetailUseCase(SucursalesDataApi());
  },
);
