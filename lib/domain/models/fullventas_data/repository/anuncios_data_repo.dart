import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';

abstract class AnunciosDataRepo {
  Future<List<AnunciosData>> getAnunciosBySeccion(String seccion);
}
