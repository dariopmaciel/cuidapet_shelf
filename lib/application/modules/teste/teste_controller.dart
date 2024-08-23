import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'teste_controller.g.dart';

class TesteController {
  @Route.get('/')
  Future<Response> find(Request request) async {
    print('>>>>>>>INICIANDO TESTE CONTROLLER');
    //caso não feito como exemplo abaixo, pode ser feito um Middlerware que efetue isto automaticamnete
    //como foi feito
    final resp=  Response.ok(jsonEncode({'message': 'hello'}));
    //apresenta como JSON
    // final resp=  Response.ok(jsonEncode({'message': 'hello'}),headers: {'content-type': 'application/json'});
    print('>>>>>>FINALIZANDO TESTE CONTROLLER');
    return resp;
  }

  Router get router => _$TesteControllerRouter(this);
}
