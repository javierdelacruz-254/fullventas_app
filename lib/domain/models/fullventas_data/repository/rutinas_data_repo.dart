import 'package:fullventas_app/domain/models/fullventas_data/rutinas_data.dart';

abstract class RutinasDataRepo {
  Future<List<RutinasData>> getRutinasById(int idCliente);
}
