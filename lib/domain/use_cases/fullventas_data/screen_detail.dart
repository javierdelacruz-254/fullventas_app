import 'package:fullventas_app/domain/models/fullventas_data/repository/screen_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/screen_data.dart';

class ScreenDetailUseCase {
  final ScreenDataRepo screenDataRepo;
  ScreenDetailUseCase(this.screenDataRepo);
  Future<List<ScreenData>> getScreenData() =>
      screenDataRepo.getScreenDataRepo();
}
