import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_image_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/estretegia_venta_image_data_repo.dart';

class EstrategiaVentasImageDetailUseCase {
  EstretegiaVentaImageDataRepo estretegiaVentaImageDataRepo;
  EstrategiaVentasImageDetailUseCase(this.estretegiaVentaImageDataRepo);
  Future<List<EstrategiaVentasImageData>> getEstrategiaVentasImageById(
      int estrategiaId) async {
    return await estretegiaVentaImageDataRepo
        .getEstrategiaVentasImageById(estrategiaId);
  }
}
