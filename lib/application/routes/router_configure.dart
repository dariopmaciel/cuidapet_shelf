// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/modules/teste/teste_router.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/routes/i_router.dart';

class RouterConfigure {
  
  final Router _router;
  final List<IRouter> _routers = [
    TesteRouter(),
    // UserRouter(),
    //ChatRouter(),
    //SupplierRouter(),
  ];

  RouterConfigure(this._router);

  // ignore: avoid_function_literals_in_foreach_calls
  void configure() => _routers.forEach((element) => element.configure(_router),
      );
}
