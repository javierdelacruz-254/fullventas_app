import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/publicaciones_data_repo.dart';

class PublicacionesDetailUseCase {
  final PublicacionesDataRepo publicacionesDataRepo;
  PublicacionesDetailUseCase(this.publicacionesDataRepo);
  Future<List<PublicacionesData>> getPublicacionesData() =>
      publicacionesDataRepo.getPublicacionesDataRepo();
}
