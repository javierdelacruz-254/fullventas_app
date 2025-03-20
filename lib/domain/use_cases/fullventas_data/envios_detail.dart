import 'package:fullventas_app/domain/models/fullventas_data/envios_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/envios_data_repo.dart';

class EnviosDetailUseCase {
  final EnviosDataRepo enviosDataRepo;
  EnviosDetailUseCase(this.enviosDataRepo);
  Future<List<EnviosData>> getEnviosById(int sucursalId) async {
    return await enviosDataRepo.getEnviosById(sucursalId);
  }
}
