import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/categories_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/categories_data_repo.dart';

class CategoriesDataNotifier extends StateNotifier<List<CategoriesData>> {
  final CategoriesDataRepo categoriesDataRepo;

  CategoriesDataNotifier(this.categoriesDataRepo) : super([]) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await categoriesDataRepo.getCategoriesDataRepo();
      state = categories.where((c) => c.status == 1).toList();
    } catch (e) {
      state = [];
    }
  }
}
