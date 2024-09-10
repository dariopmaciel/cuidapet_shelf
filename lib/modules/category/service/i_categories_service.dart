import 'package:cuidapet_shelf/entities/category.dart';

abstract interface class ICategoriesService {
  Future<List<Category>>findAll();

}