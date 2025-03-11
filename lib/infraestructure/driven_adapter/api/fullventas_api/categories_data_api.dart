import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/categories_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/categories_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class CategoriesDataApi extends CategoriesDataRepo {
  @override
  Future<List<CategoriesData>> getCategoriesDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getCategorias);
    if (response.statusCode == 200) {
      final categoriesData = categoriesDataFromJson(response.body);
      return categoriesData;
    } else {
      throw CategoriesDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
