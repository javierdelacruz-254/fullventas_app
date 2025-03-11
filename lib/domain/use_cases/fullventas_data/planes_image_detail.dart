import 'package:fullventas_app/domain/models/fullventas_data/planes_image_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/planes_image_data_repo.dart';

class PlanesImageDetailUseCase {
  final PlanesImageDataRepo planesImageDataRepo;
  PlanesImageDetailUseCase(this.planesImageDataRepo);
  Future<List<PlanesImageData>> getPlanesImageById(int planId) async {
    return await planesImageDataRepo.getPlanesImageById(planId);
  }
}
