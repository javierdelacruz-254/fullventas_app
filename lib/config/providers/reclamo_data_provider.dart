import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/reclamo_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/reclamo_data_api.dart';

final reclamoDataProvider = Provider<ReclamoDetailUseCase>((ref) {
  return ReclamoDetailUseCase(ReclamoDataApi());
});
