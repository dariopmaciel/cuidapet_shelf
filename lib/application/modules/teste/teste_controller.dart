import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'teste_controller.g.dart';

class TesteController {
  @Route.get('/')
  Future<Response> find(Request request) async {
    print('>>>>>>>INICIANDO TESTE CONTROLLER');
    final resp=  Response.ok(jsonEncode({'message': "hello"}));
    print('>>>>>>FINALIZANDO TESTE CONTROLLER');
    return resp;
  }

  Router get router => _$TesteControllerRouter(this);
}
