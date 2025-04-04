import 'package:fullventas_app/domain/models/fullventas_data/envios_data.dart';

abstract class EnviosDataRepo {
  Future<List<EnviosData>> getEnviosById(int sucursalId);
}
