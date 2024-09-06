// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

// import 'package:injectable/injectable.dart';
import 'package:cuidapet_shelf/application/exceptions/user_not_found_exception.dart';
import 'package:cuidapet_shelf/application/helpers/jwt_helper.dart';
import 'package:cuidapet_shelf/entities/user.dart';
import 'package:cuidapet_shelf/modules/user/view_models/login_view_model.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_confirm_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/user/service/i_user_service.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;

      if (!loginViewModel.socialLogin) {
        user = await userService.loginWithUserEmailPassword(
            loginViewModel.login,
            loginViewModel.password,
            loginViewModel.supplierUser);
      } else {
        //social login(facebook, google , apple)
        user = await userService.loginWithSocial(
            loginViewModel.login,
            loginViewModel.avatar,
            loginViewModel.socialType,
            loginViewModel.socialKey);
      }

      return Response.ok(
        jsonEncode(
          {'access_token': JwtHelper.generateJWT(user.id!, user.supplierId)},
        ),
      );
    } on UserNotFoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuário ou senha invalidos!'}));
    } catch (e, s) {
      log.error("Erro ao fazer login", e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao realizar login.'}));
    }
  }

//     '/auth/register'
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

  @Route('PATCH', '/confirm')
  Future<Response> confirmLogin(Request request) async {
    final user = int.parse(request.headers['user']!);
    final supplier = int.tryParse(request.headers['supplier'] ?? '');
    final token =
        JwtHelper.generateJWT(user, supplier).replaceAll('Bearer ', '');
    final inputModel = UserConfirmInputModel(
      userId: user,
      accessToken: token,
      data: await request.readAsString(),
    );
    final refreshToken = await userService.confirmLogin(inputModel);

    return Response.ok(jsonEncode({
      'access_token': 'Bearer $token',
      'refresh_token': refreshToken,
    }));
  }

  @Route.put('/refresh')
  Future<Response> refreshToken(Request request) async {
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$AuthControllerRouter(this);
}
