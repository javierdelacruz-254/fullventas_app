import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/size_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/size_data.dart';
import 'package:http/http.dart' as http;

class SizeDataApi extends SizeDataRepo {
  @override
  Future<List<SizeData>> getSizeById(int sizeId) async {
    final response = await http.get(Uri.parse(AppRoutes.getSizeId(sizeId)));
    if (response.statusCode == 200) {
      final sizeData = sizeDataFromJson(response.body);
      return sizeData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
