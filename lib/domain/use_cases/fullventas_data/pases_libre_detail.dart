import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/pases_libre_data_repo.dart';

class PasesLibreDetailUseCase {
  final PasesLibreDataRepo pasesLibreDataRepo;
  PasesLibreDetailUseCase(this.pasesLibreDataRepo);
  Future<List<PasesLibreData>> getPasesLibresData() =>
      pasesLibreDataRepo.getPasesLibresDataRepo();
}
