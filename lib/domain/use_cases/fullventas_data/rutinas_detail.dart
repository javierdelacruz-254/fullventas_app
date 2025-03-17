import 'package:fullventas_app/domain/models/fullventas_data/repository/rutinas_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/rutinas_data.dart';

class RutinasDetailUseCase {
  final RutinasDataRepo rutinasDataRepo;
  RutinasDetailUseCase(this.rutinasDataRepo);
  Future<List<RutinasData>> getRutinasById(int idCliente) async {
    return await rutinasDataRepo.getRutinasById(idCliente);
  }
}
