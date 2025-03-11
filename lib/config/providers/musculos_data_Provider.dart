import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/musculos_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/musculos_data_api.dart';

final musculosDataProvider = Provider<MusculosDetailUseCase>(
  (ref) {
    return MusculosDetailUseCase(MusculosDataApi());
  },
);
