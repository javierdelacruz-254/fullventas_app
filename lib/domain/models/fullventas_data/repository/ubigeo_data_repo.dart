import 'package:fullventas_app/domain/models/fullventas_data/ubigeo_data.dart';

abstract class UbigeoDataRepo {
  Future<List<UbigeoData>> getDepartamento();
  Future<List<UbigeoData>> getProvincias(String idDepartamento);
  Future<List<UbigeoData>> getDistritos(String idProvincia);
}
