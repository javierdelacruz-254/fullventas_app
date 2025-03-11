import 'package:fullventas_app/domain/models/fullventas_data/categories_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/categories_data_repo.dart';

class CategoriesDetailUseCase {
  final CategoriesDataRepo categoriesDataRepo;
  CategoriesDetailUseCase(this.categoriesDataRepo);
  Future<List<CategoriesData>> getCategoriesData() =>
      categoriesDataRepo.getCategoriesDataRepo();
}
