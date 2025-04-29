import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/anuncios_data_repo.dart';

class AnunciosDetailUseCase {
  final AnunciosDataRepo anunciosDataRepo;
  AnunciosDetailUseCase(this.anunciosDataRepo);
  Future<List<AnunciosData>> getAnunciosBySeccion(String seccion) async {
    return await anunciosDataRepo.getAnunciosBySeccion(seccion);
  }
}
