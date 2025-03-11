import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/cliente_data_repo.dart';

class LoginDetailUseCase {
  final ClienteDataRepo clienteDataRepo;
  LoginDetailUseCase(this.clienteDataRepo);
  Future<ClienteData?> login(String codigo) async {
    return await clienteDataRepo.login(codigo);
  }
}
