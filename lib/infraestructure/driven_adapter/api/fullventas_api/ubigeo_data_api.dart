import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/ubigeo_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/ubigeo_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class UbigeoDataApi extends UbigeoDataRepo {
  @override
  Future<List<UbigeoData>> getDepartamento() async {
    final response = await HttpHelperGet.get(AppRoutes.getDepartamentos);
    if (response.statusCode == 200) {
      final departamentoData = ubigeoDataFromJson(response.body);
      return departamentoData;
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  @override
  Future<List<UbigeoData>> getDistritos(String idProvincia) async {
    final response =
        await HttpHelperGet.get(AppRoutes.getDistritos(idProvincia));
    if (response.statusCode == 200) {
      final distritosData = ubigeoDataFromJson(response.body);
      return distritosData;
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  @override
  Future<List<UbigeoData>> getProvincias(String idDepartamento) async {
    final response =
        await HttpHelperGet.get(AppRoutes.getProvincias(idDepartamento));
    if (response.statusCode == 200) {
      final provinciasData = ubigeoDataFromJson(response.body);
      return provinciasData;
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }
}
