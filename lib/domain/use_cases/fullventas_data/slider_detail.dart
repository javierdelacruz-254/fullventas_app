import 'package:fullventas_app/domain/models/fullventas_data/repository/slider_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/slider_data.dart';

class SliderDetailUseCase {
  final SliderDataRepo sliderDataRepo;
  SliderDetailUseCase(this.sliderDataRepo);
  Future<List<SliderData>> getSliderData() =>
      sliderDataRepo.getSliderDataRepo();
}
