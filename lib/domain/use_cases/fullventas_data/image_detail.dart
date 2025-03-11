import 'package:fullventas_app/domain/models/fullventas_data/images_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/image_data_repo.dart';

class ImageDetailUseCase {
  final ImageDataRepo imageDataRepo;
  ImageDetailUseCase(this.imageDataRepo);
  Future<List<ImageData>> getImageById(int productId) async {
    return await imageDataRepo.getImagesById(productId);
  }
}
