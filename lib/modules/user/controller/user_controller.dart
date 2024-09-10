// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_shelf/modules/user/view_models/update_url_avatar_view_model.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_update_device_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/exceptions/user_not_found_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/user/service/i_user_service.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  IUserService userService;
  ILogger log;

  UserController({
    required this.userService,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final userData = await userService.findById(user);

      return Response.ok(jsonEncode({
        'email': userData.email,
        'register_type': userData.registerType,
        'img_avatar': userData.imageAvatar,
      }));
    } on UserNotFoundException {
      return Response(204, body: jsonEncode(''));
    } catch (e, s) {
      log.error("Erro ao buscar usuario", e, s);
      return Response.internalServerError(
          body: jsonEncode({"message": "Erro ao buscar usuario"}));
    }
  }

  @Route.put('/avatar')
  Future<Response> updateAvatar(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final updateUrlAvatarViewModel = UpdateUrlAvatarViewModel(
        userId: userId,
        dataRequest: await request.readAsString(),
      );

      final user = await userService.updateAvatar(updateUrlAvatarViewModel);

      return Response.ok(jsonEncode({
        'email': user.email,
        'register_type': user.registerType,
        'img_avatar': user.imageAvatar,
      }));
    } catch (e) {
      return Response.internalServerError(
          body: {'message': 'Erro ao atualizar Avaaaaatar'});
    }
  }

  @Route.put('/device')
  Future<Response> updateDeviceToken(Request request) async {
    final updateDeviceToken = UserUpdateDeviceInputModel(
      userId: int.parse(request.headers['user']!),
      dataRequest: await request.readAsString(),
    );

    return Response.ok(jsonEncode(''));
  }

  Router get router => _$UserControllerRouter(this);
}
