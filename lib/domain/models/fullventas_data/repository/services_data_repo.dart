import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';

abstract class ServicesDataRepo {
  Future<List<ServicesData>> getServicesDataRepo();
}
