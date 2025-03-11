import 'package:fullventas_app/domain/models/fullventas_data/destination_type_data.dart';

abstract class DestinationTypeDataRepo {
  Future<List<DestinationTypeData>> getDestinationType();
}
