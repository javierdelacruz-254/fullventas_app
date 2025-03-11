import 'package:fullventas_app/domain/models/fullventas_data/destination_type_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/destination_type_data_repo.dart';

class DestinationDetailUseCase {
  final DestinationTypeDataRepo destinationTypeDataRepo;
  DestinationDetailUseCase(this.destinationTypeDataRepo);
  Future<List<DestinationTypeData>> getDestionationTypeData() =>
      destinationTypeDataRepo.getDestinationType();
}
