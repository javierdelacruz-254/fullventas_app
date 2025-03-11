import 'package:fullventas_app/domain/models/fullventas_data/musculos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/musculos_data_repo.dart';

class MusculosDetailUseCase {
  final MusculosDataRepo musculosDataRepo;
  MusculosDetailUseCase(this.musculosDataRepo);
  Future<List<MusculosData>> getMusculosById(int idGrupo) async {
    return await musculosDataRepo.getMusculosById(idGrupo);
  }
}
