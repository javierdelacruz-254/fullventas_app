import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';

abstract class DescuentosDataRepo {
  Future<List<DescuentosData>> getDescuentosDataRepo();
}
