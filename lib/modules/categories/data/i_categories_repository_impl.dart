import 'package:cuidapet_shelf/modules/categories/service/i_categories_service_impl.dart';
import 'package:injectable/injectable.dart';

import './i_categories_repository.dart';

@LazySingleton(as: ICategoriesRepository)
class ICategoriesRepositoryImpl implements ICategoriesRepository {}
