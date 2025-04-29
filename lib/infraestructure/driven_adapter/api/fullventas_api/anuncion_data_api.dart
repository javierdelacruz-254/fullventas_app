import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/anuncios_data_repo.dart';
import 'package:http/http.dart' as http;

class AnuncionDataApi extends AnunciosDataRepo {
  @override
  Future<List<AnunciosData>> getAnunciosBySeccion(String seccion) async {
    final response =
        await http.get(Uri.parse(AppRoutes.getPublicidad(seccion)));
    if (response.statusCode == 200) {
      final anuncioData = publicidadDataFromJson(response.body);
      return anuncioData;
    } else {
      throw Exception(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
