import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/ubigeo_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/ubigeo_data.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/ubigeo_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/ubigeo_data_api.dart';

final ubigeoDataRepo = Provider<UbigeoDataRepo>((ref) {
  return UbigeoDataApi();
});

final ubigeoDetailUseCase = Provider<UbigeoDetailUseCase>((ref) {
  final repo = ref.watch(ubigeoDataRepo);
  return UbigeoDetailUseCase(repo);
});

final departamentosDataProvider = FutureProvider<List<UbigeoData>>((ref) async {
  final useCase = ref.watch(ubigeoDetailUseCase);
  return useCase.getDepartamento();
});

final provinciasDataProvider = FutureProvider.family<List<UbigeoData>, String>(
    (ref, idDepartamento) async {
  final useCase = ref.watch(ubigeoDetailUseCase);
  return useCase.getProvincias(idDepartamento);
});

final distritosDataProvider =
    FutureProvider.family<List<UbigeoData>, String>((ref, idProvincia) async {
  final useCase = ref.watch(ubigeoDetailUseCase);
  return useCase.getDistritos(idProvincia);
});
