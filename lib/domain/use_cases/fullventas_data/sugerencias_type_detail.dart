import 'package:fullventas_app/domain/models/fullventas_data/repository/sugerencias_type_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_type_data.dart';

class SugerenciasTypeDetailUseCase {
  final SugerenciasTypeDataRepo sugerenciasTypeDataRepo;
  SugerenciasTypeDetailUseCase(this.sugerenciasTypeDataRepo);
  Future<List<SugerenciasTypeData>> getSugerenciasTypeData() =>
      sugerenciasTypeDataRepo.getSugerenciasTypeRepo();
}
