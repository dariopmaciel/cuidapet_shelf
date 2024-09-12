import 'package:cuidapet_shelf/application/routes/i_router.dart';
import 'package:cuidapet_shelf/modules/supplier/controller/supplier_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_router/src/router.dart';

class SupplierRouter implements IRouter {
  @override
  void configure(Router router) {
    final supplierController = GetIt.I.get<SupplierController>();

    router.mount("/suppliers/", supplierController.router.call);
  }
}
