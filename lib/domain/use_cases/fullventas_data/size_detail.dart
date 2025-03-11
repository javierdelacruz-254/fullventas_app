import 'package:fullventas_app/domain/models/fullventas_data/repository/size_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/size_data.dart';

class SizeDetailUseCase {
  final SizeDataRepo sizeDataRepo;
  SizeDetailUseCase(this.sizeDataRepo);
  Future<List<SizeData>> getSizeById(int sizeId) async {
    return await sizeDataRepo.getSizeById(sizeId);
  }
}
