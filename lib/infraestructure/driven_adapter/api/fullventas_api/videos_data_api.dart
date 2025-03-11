import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/publicaciones_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class VideosDataApi extends PublicacionesDataRepo {
  @override
  Future<List<PublicacionesData>> getPublicacionesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getPublicaciones);
    if (response.statusCode == 200) {
      final videosData = publicacionesDataFromJson(response.body);
      return videosData;
    } else {
      throw PublicacionesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
