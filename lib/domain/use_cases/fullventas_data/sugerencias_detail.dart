import 'package:fullventas_app/domain/models/fullventas_data/repository/sugerencias_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_data.dart';

class SugerenciasDetailUseCase {
  final SugerenciasDataRepo sugerenciasDataRepo;
  SugerenciasDetailUseCase(this.sugerenciasDataRepo);
  Future<void> execute(SugerenciasData sugerencia) async {
    await sugerenciasDataRepo.saveSugerencia(sugerencia);
  }
}
