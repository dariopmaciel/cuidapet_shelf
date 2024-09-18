// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/modules/chat/view_models/chat_notify_view_model.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/modules/chat/data/i_chat_repository.dart';
import 'package:cuidapet_shelf/modules/chat/service/i_chat_service.dart';

@LazySingleton(as: IChatService)
class IChatServiceImpl implements IChatService {
  final IChatRepository repository;
  IChatServiceImpl({required this.repository});

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);

  @override
  Future<void> notifyChat(ChatNotifyViewModel model) async {
    final chat = await repository.findChatById(model.chat);

    switch (model.notificationUserType) {
      case NotificationUserType.user:
        break;
      case NotificationUserType.supplier:
        break;
      default:
        throw Exception('Tipo de notificação não encontrada');
    }
  }
}
