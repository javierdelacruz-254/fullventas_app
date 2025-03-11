import 'package:fullventas_app/domain/models/fullventas_data/disciplinas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/disciplinas_data_repo.dart';

class DisciplinasDetailUseCase {
  final DisciplinasDataRepo disciplinasDataRepo;
  DisciplinasDetailUseCase(this.disciplinasDataRepo);
  Future<List<DisciplinasData>> getDisciplinasData() =>
      disciplinasDataRepo.getDisciplinasDataRepo();
}
