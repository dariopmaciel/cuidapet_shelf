import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

class SupplierController {

@Injectable()
   @Route.get('/')
   Future<Response> findNearByMe(Request request) async { 
      return Response.ok(jsonEncode(''));
   }

   Router get router => _$SupplierControllerRouter(this);
}