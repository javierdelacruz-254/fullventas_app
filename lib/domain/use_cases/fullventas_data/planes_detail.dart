import 'package:fullventas_app/domain/models/fullventas_data/planes_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/planes_data_repo.dart';

class PlanesDetailUseCase {
  final PlanesDataRepo planesDataRepo;
  PlanesDetailUseCase(this.planesDataRepo);
  Future<List<PlanesData>> getPlanesData() =>
      planesDataRepo.getPlanesDataRepo();
}
