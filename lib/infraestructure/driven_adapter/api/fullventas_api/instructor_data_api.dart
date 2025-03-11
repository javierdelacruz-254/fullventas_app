import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/instructor_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/instructor_data_repo.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';

class InstructorDataApi extends InstructorDataRepo {
  @override
  Future<List<InstructorData>> getInstructorDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getIntructor);
    if (response.statusCode == 200) {
      final instructorData = instructorDataFromJson(response.body);
      return instructorData;
    } else {
      throw InstructorDataApiError(
          'Error al obtener los datos. Código de estado ${response.statusCode}');
    }
  }
}
