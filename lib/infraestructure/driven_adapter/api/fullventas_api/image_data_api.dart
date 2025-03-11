import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/images_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/image_data_repo.dart';
import 'package:http/http.dart' as http;

class ImageDataApi extends ImageDataRepo {
  @override
  Future<List<ImageData>> getImagesById(int productId) async {
    final response =
        await http.get(Uri.parse(AppRoutes.getProductImage(productId)));
    if (response.statusCode == 200) {
      final imageData = imageDataFromJson(response.body);
      print(response.body);
      return imageData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
