import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/planes_image_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/planes_image_data_repo.dart';
import 'package:http/http.dart' as http;

class PlanesImageDataApi extends PlanesImageDataRepo {
  @override
  Future<List<PlanesImageData>> getPlanesImageById(int planId) async {
    final response = await http.get(Uri.parse(AppRoutes.getPlanesImg(planId)));
    if (response.statusCode == 200) {
      final planesImageData = planesImageDataFromJson(response.body);
      return planesImageData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
