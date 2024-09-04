import 'package:cuidapet_shelf/application/routes/i_router.dart';
import 'package:cuidapet_shelf/modules/user/controller/auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';



class UserRouter implements IRouter {
  @override
  Future<void> configure(Router router) async {
    final authController = GetIt.instance.get<AuthController>();

    router.mount('/auth/', authController.router.call);
  }
}
