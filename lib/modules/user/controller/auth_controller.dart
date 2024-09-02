// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';


// import 'package:injectable/injectable.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/user/service/i_user_service.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

part 'auth_controller.g.dart';

@ Injectable()//add no getit
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());

      await userService.createUser(userModel);
      return Response.ok(jsonEncode('Cadastro realizado com sucessos'));
    } on UserExistsException {
      return Response(
        400,
        body: jsonEncode("Usuario já cadastrado na Base de Dados"),
      );
    } catch (e) {
      log.error('Erro ao cadastrar Usuário', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
