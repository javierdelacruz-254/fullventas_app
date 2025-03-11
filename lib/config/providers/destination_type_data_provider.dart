import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/destination_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/destination_type_data_api.dart';

final destinationTypeDataProvider = Provider<DestinationDetailUseCase>(
  (ref) {
    return DestinationDetailUseCase(DestinationTypeDataApi());
  },
);
