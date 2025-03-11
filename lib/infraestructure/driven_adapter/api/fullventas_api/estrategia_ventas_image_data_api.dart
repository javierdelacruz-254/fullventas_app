import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_image_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/estretegia_venta_image_data_repo.dart';
import 'package:http/http.dart' as http;

class EstrategiaVentasImageDataApi extends EstretegiaVentaImageDataRepo {
  @override
  Future<List<EstrategiaVentasImageData>> getEstrategiaVentasImageById(
      int estrategiaId) async {
    final response =
        await http.get(Uri.parse(AppRoutes.getEstrategiaImg(estrategiaId)));
    if (response.statusCode == 200) {
      final estrategiaVentasImageData =
          estrategiaVentasImageDataFromJson(response.body);
      return estrategiaVentasImageData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
