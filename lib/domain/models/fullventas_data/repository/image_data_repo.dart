import 'package:fullventas_app/domain/models/fullventas_data/images_data.dart';

abstract class ImageDataRepo {
  Future<List<ImageData>> getImagesById(int productId);
}
