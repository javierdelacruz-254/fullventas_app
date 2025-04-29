import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/screen_data.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/screen_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/screen_data_api.dart';

final screenDataProvider = FutureProvider<List<ScreenData>>(
  (ref) async {
    final useCase = ScreenDetailUseCase(ScreenDataApi());
    return await useCase.getScreenData();
  },
);
