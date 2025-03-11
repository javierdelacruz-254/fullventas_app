import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';

abstract class SucursalesDataRepo {
  Future<List<SucursalesData>> getSucursalesDataRepo();
}
