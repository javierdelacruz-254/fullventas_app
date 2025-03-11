import 'package:fullventas_app/domain/models/fullventas_data/grupo_musculares_data.dart';

abstract class GrupoMuscularesDataRepo {
  Future<List<GrupoMuscularesData>> getGrupoMuscularesDataRepo();
}
