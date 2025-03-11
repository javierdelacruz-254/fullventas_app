import 'package:fullventas_app/domain/models/fullventas_data/repository/services_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';

class ServicesDetailUseCase {
  final ServicesDataRepo servicesDataRepo;
  ServicesDetailUseCase(this.servicesDataRepo);
  Future<List<ServicesData>> getServicesData() =>
      servicesDataRepo.getServicesDataRepo();
}
