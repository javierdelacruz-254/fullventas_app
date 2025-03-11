import 'package:fullventas_app/domain/models/fullventas_data/screen_data.dart';

abstract class ScreenDataRepo {
  Future<List<ScreenData>> getScreenDataRepo();
}
