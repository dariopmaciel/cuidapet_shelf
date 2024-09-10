import 'package:cuidapet_shelf/entities/category.dart';

abstract interface class ICategoriesRepository {
  Future<List<Category>> findAll();
}
