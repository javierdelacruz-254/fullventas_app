import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';

abstract class PublicacionesDataRepo {
  Future<List<PublicacionesData>> getPublicacionesDataRepo();
}
