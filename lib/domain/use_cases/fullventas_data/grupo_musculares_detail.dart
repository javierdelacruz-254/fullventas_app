import 'package:fullventas_app/domain/models/fullventas_data/grupo_musculares_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/grupo_musculares_data_repo.dart';

class GrupoMuscularesDetailUseCase {
  final GrupoMuscularesDataRepo grupoMuscularesDataRepo;
  GrupoMuscularesDetailUseCase(this.grupoMuscularesDataRepo);
  Future<List<GrupoMuscularesData>> getGrupoMuscularesData() =>
      grupoMuscularesDataRepo.getGrupoMuscularesDataRepo();
}
