import 'package:fullventas_app/domain/models/fullventas_data/calificacion_instructor_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/calificacion_instructor_data_repo.dart';

class CalificacionInstructorDetailUseCase {
  final CalificacionInstructorDataRepo calificacionInstructorDataRepo;
  CalificacionInstructorDetailUseCase(this.calificacionInstructorDataRepo);
  Future<void> execute(CalificacionInstructorData calificacion) async {
    await calificacionInstructorDataRepo.saveCalificacion(calificacion);
  }
}
