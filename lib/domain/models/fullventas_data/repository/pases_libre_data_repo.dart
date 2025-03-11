import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';

abstract class PasesLibreDataRepo {
  Future<List<PasesLibreData>> getPasesLibresDataRepo();
}
