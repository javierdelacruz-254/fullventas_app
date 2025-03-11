import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/estrategia_ventas_data_repo.dart';

class EstrategiaVentasDetailUseCase {
  final EstrategiaVentasDataRepo estrategiaVentasDataRepo;
  EstrategiaVentasDetailUseCase(this.estrategiaVentasDataRepo);
  Future<List<EstrategiaVentasData>> getEstrategiaVentasData() =>
      estrategiaVentasDataRepo.getEstrategiaVentasDataRepo();
}
