import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';

abstract class ClienteDataRepo {
  Future<ClienteData?> login(String codigo);
}
