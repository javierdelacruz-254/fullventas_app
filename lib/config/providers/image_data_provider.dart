import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/image_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/image_data_api.dart';

final imageDataProvider = Provider<ImageDetailUseCase>(
  (ref) {
    return ImageDetailUseCase(ImageDataApi());
  },
);
