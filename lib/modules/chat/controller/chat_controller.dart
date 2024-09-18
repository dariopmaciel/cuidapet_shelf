// fu-shelf-controller
import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/chat/service/i_chat_service.dart';

part 'chat_controller.g.dart';

@Injectable()
class ChatController {
  IChatService service;
  ILogger log;

  ChatController({
    required this.service,
    required this.log,
  });

  @Route.get('/')
  Future<Response> find(Request request) async {
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$ChatControllerRouter(this);
}
