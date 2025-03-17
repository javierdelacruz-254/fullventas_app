import 'package:fullventas_app/domain/models/fullventas_data/pase_libre_cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/pase_libre_cliente_data_repo.dart';

class PaseLibreClienteDetailUseCase {
  final PaseLibreClienteDataRepo paseLibreClienteDataRepo;
  PaseLibreClienteDetailUseCase(this.paseLibreClienteDataRepo);
  Future<void> execute(PaseLibreClienteData paseLibreClienteData) async {
    await paseLibreClienteDataRepo.savePaseLibreCliente(paseLibreClienteData);
  }

  Future<List<PaseLibreClienteData>> getPaseLibreClienteById(
      String nombre) async {
    return await paseLibreClienteDataRepo.getPaseLibreClienteById(nombre);
  }
}
