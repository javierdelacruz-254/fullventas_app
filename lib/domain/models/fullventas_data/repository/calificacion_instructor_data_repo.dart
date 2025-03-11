import 'package:fullventas_app/domain/models/fullventas_data/calificacion_instructor_data.dart';

abstract class CalificacionInstructorDataRepo {
  Future<void> saveCalificacion(CalificacionInstructorData calificacion);
}
