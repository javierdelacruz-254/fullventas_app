import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/publicaciones_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class PublicacionesDataApi extends PublicacionesDataRepo {
  @override
  Future<List<PublicacionesData>> getPublicacionesDataRepo() async {
    print("📡 Realizando petición a la API: ${AppRoutes.getPublicaciones}");
    final response = await HttpHelperGet.get(AppRoutes.getPublicaciones);
    print("📥 Respuesta recibida. Código de estado: ${response.statusCode}");
    if (response.statusCode == 200) {
      final publicacionesData = publicacionesDataFromJson(response.body);

      for (var publicacion in publicacionesData) {
        print("📝 Publicación ID: ${publicacion.id}");
        print("📷 Imagen: ${publicacion.image_name}");
      }
      return publicacionesData;
    } else {
      print(
          "❌ Error al obtener los datos. Código de estado: ${response.statusCode}");
      throw PublicacionesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
