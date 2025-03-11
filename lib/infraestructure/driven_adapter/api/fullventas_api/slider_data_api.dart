import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/slider_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/slider_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class SliderDataApi extends SliderDataRepo {
  @override
  Future<List<SliderData>> getSliderDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getSlider);
    if (response.statusCode == 200) {
      final sliderData = sliderDataFromJson(response.body);
      return sliderData;
    } else {
      throw SliderDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
