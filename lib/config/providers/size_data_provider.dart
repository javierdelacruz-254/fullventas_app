import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/size_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/size_data_api.dart';

final sizeDataProvider = Provider<SizeDetailUseCase>(
  (ref) {
    return SizeDetailUseCase(SizeDataApi());
  },
);
