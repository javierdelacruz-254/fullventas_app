import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_image_data.dart';

abstract class EstretegiaVentaImageDataRepo {
  Future<List<EstrategiaVentasImageData>> getEstrategiaVentasImageById(
      int estrategiaId);
}
