import 'package:fullventas_app/domain/models/fullventas_data/maquinas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/maquinas_data_repo.dart';

class MaquinasDetailUseCase {
  final MaquinasDataRepo maquinasDataRepo;
  MaquinasDetailUseCase(this.maquinasDataRepo);
  Future<List<MaquinasData>> getMaquinasById(int idGrupo) async {
    return await maquinasDataRepo.getMaquinasById(idGrupo);
  }
}
