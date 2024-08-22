
import 'package:cuidapet_shelf/application/modules/teste/teste_controller.dart';
import 'package:cuidapet_shelf/application/routes/i_router.dart';
import 'package:shelf_router/src/router.dart';

class TesteRouter implements IRouter{
  @override
  void configure(Router router) {
    router.mount("/hello/", TesteController().router.call);
  }
  
}