// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/modules/user/service/i_user_service.dart';

part 'auth_controller.g.dart';

@injectable //add no getit
class AuthController {
  IUserService userService;
  
  AuthController({required this.userService});

  @Route.get('/')
  Future<Response> find(Request request) async {
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$AuthControllerRouter(this);
}
