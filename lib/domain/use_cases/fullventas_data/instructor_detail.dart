import 'package:fullventas_app/domain/models/fullventas_data/instructor_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/instructor_data_repo.dart';

class InstructorDetailUseCase {
  final InstructorDataRepo instructorDataRepo;
  InstructorDetailUseCase(this.instructorDataRepo);
  Future<List<InstructorData>> getInstructorData() =>
      instructorDataRepo.getInstructorDataRepo();
}
