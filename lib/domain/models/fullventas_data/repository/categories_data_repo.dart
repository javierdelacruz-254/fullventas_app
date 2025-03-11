import 'package:fullventas_app/domain/models/fullventas_data/categories_data.dart';

abstract class CategoriesDataRepo {
  Future<List<CategoriesData>> getCategoriesDataRepo();
}
