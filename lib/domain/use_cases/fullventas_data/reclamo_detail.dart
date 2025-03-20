import 'package:fullventas_app/domain/models/fullventas_data/reclamo_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/reclamo_data_repo.dart';

class ReclamoDetailUseCase {
  final ReclamoDataRepo reclamoDataRepo;
  ReclamoDetailUseCase(this.reclamoDataRepo);
  Future<void> execute(ReclamoData reclamo) async {
    await reclamoDataRepo.saveReclamo(reclamo);
  }
}
