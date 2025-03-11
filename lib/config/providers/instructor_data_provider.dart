import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/instructor_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/instructor_data_api.dart';

final instructorDataProvider = Provider<InstructorDetailUseCase>(
  (ref) {
    return InstructorDetailUseCase(InstructorDataApi());
  },
);
