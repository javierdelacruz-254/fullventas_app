import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/anuncios_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/anuncion_data_api.dart';

final anunciosDataProvider = Provider<AnunciosDetailUseCase>((ref) {
  return AnunciosDetailUseCase(AnuncionDataApi());
});
