import 'package:fullventas_app/domain/models/fullventas_data/planes_data.dart';

abstract class PlanesDataRepo {
  Future<List<PlanesData>> getPlanesDataRepo();
}
