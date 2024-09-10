import 'package:cuidapet_shelf/application/routes/i_router.dart';
import 'package:cuidapet_shelf/modules/category/controller/categories_controller.dart';

import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class CategoriesRouters implements IRouter {
  @override
  void configure(Router router) {
    final categoriesController = GetIt.I.get<CategoriesController>();
    //*-------------------------------------------
    router.mount('/categories/', categoriesController.router.call);
  }
}
