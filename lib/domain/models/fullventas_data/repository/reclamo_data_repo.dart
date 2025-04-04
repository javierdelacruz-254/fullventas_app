import 'package:fullventas_app/domain/models/fullventas_data/reclamo_data.dart';

abstract class ReclamoDataRepo {
  Future<void> saveReclamo(ReclamoData reclamo);
}
