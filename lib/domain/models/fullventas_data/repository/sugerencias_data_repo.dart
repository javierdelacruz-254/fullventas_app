import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_data.dart';

abstract class SugerenciasDataRepo {
  Future<void> saveSugerencia(SugerenciasData sugerencia);
}
