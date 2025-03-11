import 'package:fullventas_app/domain/models/fullventas_data/slider_data.dart';

abstract class SliderDataRepo {
  Future<List<SliderData>> getSliderDataRepo();
}
