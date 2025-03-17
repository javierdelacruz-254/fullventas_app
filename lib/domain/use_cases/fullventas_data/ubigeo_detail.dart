import 'package:fullventas_app/domain/models/fullventas_data/repository/ubigeo_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/ubigeo_data.dart';

class UbigeoDetailUseCase {
  final UbigeoDataRepo ubigeoDataRepo;
  UbigeoDetailUseCase(this.ubigeoDataRepo);

  Future<List<UbigeoData>> getDepartamento() =>
      ubigeoDataRepo.getDepartamento();

  Future<List<UbigeoData>> getProvincias(String idDepartamento) async {
    return await ubigeoDataRepo.getProvincias(idDepartamento);
  }

  Future<List<UbigeoData>> getDistritos(String idProvincia) async {
    return await ubigeoDataRepo.getDistritos(idProvincia);
  }
}
