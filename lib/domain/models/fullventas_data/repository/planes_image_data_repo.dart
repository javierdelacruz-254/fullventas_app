import 'package:fullventas_app/domain/models/fullventas_data/planes_image_data.dart';

abstract class PlanesImageDataRepo {
  Future<List<PlanesImageData>> getPlanesImageById(int planId);
}
