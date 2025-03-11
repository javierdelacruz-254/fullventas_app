import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/descuentos_data_repo.dart';

class DescuentosDetailUseCase {
  final DescuentosDataRepo descuentosDataRepo;
  DescuentosDetailUseCase(this.descuentosDataRepo);
  Future<List<DescuentosData>> getDescuentosData() =>
      descuentosDataRepo.getDescuentosDataRepo();
}
