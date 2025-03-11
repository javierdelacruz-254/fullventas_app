import 'package:fullventas_app/domain/models/fullventas_data/instructor_data.dart';

abstract class InstructorDataRepo {
  Future<List<InstructorData>> getInstructorDataRepo();
}
