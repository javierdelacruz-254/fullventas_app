import 'package:fullventas_app/domain/models/fullventas_data/disciplinas_data.dart';

abstract class DisciplinasDataRepo {
  Future<List<DisciplinasData>> getDisciplinasDataRepo();
}
