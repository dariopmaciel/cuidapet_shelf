// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_shelf/modules/chat/view_models/chat_notify_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/chat/service/i_chat_service.dart';

part 'chat_controller.g.dart';

@Injectable()
class ChatController {
  final IChatService service;
  final ILogger log;

  ChatController({
    required this.service,
    required this.log,
  });

  @Route.post('/schedule/<scheduleId>/start-chat')
  Future<Response> startChatBySchedule(
      Request request, String scheduleId) async {
    try {
      final chatId = await service.startChat(int.parse(scheduleId));
      return Response.ok(jsonEncode({'chat_id': chatId}));
    } catch (e, s) {
      log.error("Erro ao iniciar CHAT", e, s);
      return Response.internalServerError();
    }
  }

  @Route.post('/notify')
  Future<Response> notifyUser(Request request) async {
    try {
      final model = ChatNotifyViewModel(await request.readAsString());
      await service.notifyChat(model);
      return Response.ok(jsonEncode({'ok'}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode(
          {'Message': "Erro ao enviar notificação "},
        ),
      );
    }
  }

  Router get router => _$ChatControllerRouter(this);
}
