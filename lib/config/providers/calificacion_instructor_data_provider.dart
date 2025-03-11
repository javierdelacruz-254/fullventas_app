import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/calificacion_instructor_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/calificacion_instructor_data_api.dart';

final calificacionInstructorDataProvider =
    Provider<CalificacionInstructorDetailUseCase>(
  (ref) {
    return CalificacionInstructorDetailUseCase(CalificacionInstructorDataApi());
  },
);
