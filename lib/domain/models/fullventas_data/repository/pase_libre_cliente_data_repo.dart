import 'package:fullventas_app/domain/models/fullventas_data/pase_libre_cliente_data.dart';

abstract class PaseLibreClienteDataRepo {
  Future<void> savePaseLibreCliente(PaseLibreClienteData paseLibreCliente);
}
