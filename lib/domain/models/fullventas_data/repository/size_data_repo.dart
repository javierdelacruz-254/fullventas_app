import 'package:fullventas_app/domain/models/fullventas_data/size_data.dart';

abstract class SizeDataRepo {
  Future<List<SizeData>> getSizeById(int sizeId);
}
