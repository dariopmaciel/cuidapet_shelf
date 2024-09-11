import 'package:cuidapet_shelf/modules/category/categories_routers.dart';
import 'package:cuidapet_shelf/modules/supplier/supplier_router.dart';
import 'package:cuidapet_shelf/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:cuidapet_shelf/application/routes/i_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
    CategoriesRouters(),
    SupplierRouter(),
  ];

  RouterConfigure(this._router);

  // ignore: avoid_function_literals_in_foreach_calls
  void configure() => _routers.forEach((element) => element.configure(_router));
}
