import 'package:fullventas_app/domain/models/fullventas_data/repository/sucursales_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';

class SucursalesDetailUseCase {
  final SucursalesDataRepo sucursalesDataRepo;
  SucursalesDetailUseCase(this.sucursalesDataRepo);
  Future<List<SucursalesData>> getSucursalesData() =>
      sucursalesDataRepo.getSucursalesDataRepo();
}
