import 'package:fullventas_app/domain/models/fullventas_data/musculos_data.dart';

abstract class MusculosDataRepo {
  Future<List<MusculosData>> getMusculosById(int idGrupo);
}
