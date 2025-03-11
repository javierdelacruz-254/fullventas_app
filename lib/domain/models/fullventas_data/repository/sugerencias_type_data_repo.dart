import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_type_data.dart';

abstract class SugerenciasTypeDataRepo {
  Future<List<SugerenciasTypeData>> getSugerenciasTypeRepo();
}
