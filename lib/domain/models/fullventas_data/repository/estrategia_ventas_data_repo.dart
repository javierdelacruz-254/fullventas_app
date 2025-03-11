import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';

abstract class EstrategiaVentasDataRepo {
  Future<List<EstrategiaVentasData>> getEstrategiaVentasDataRepo();
}
