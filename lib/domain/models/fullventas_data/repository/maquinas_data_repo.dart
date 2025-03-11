import 'package:fullventas_app/domain/models/fullventas_data/maquinas_data.dart';

abstract class MaquinasDataRepo {
  Future<List<MaquinasData>> getMaquinasById(int idGrupo);
}
