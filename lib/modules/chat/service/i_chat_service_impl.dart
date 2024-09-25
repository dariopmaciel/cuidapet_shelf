// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/application/facades/push_notification_facede.dart';
import 'package:cuidapet_shelf/entities/chat.dart';
import 'package:cuidapet_shelf/modules/chat/view_models/chat_notify_view_model.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/modules/chat/data/i_chat_repository.dart';
import 'package:cuidapet_shelf/modules/chat/service/i_chat_service.dart';

@LazySingleton(as: IChatService)
class IChatServiceImpl implements IChatService {
  final IChatRepository repository;
  final PushNotificationFacede pushNotificationFacede;

  IChatServiceImpl({
    required this.repository,
    required this.pushNotificationFacede,
  });

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);

  @override
  Future<void> notifyChat(ChatNotifyViewModel model) async {
    final chat = await repository.findChatById(model.chat);

    if (chat != null) {
      switch (model.notificationUserType) {
        case NotificationUserType.user:
          _notifyUser(chat.userDeviceToken?.tokens, model, chat);
          break;
        case NotificationUserType.supplier:
          _notifyUser(chat.supplierDeviceToken?.tokens, model, chat);
          break;
        default:
          throw Exception('Tipo de notificação não encontrada');
      }
    }
  }

  void _notifyUser(
      List<String?>? tokens, ChatNotifyViewModel model, Chat chat) {
    //necessário payload
    final payload = <String, dynamic>{
      'type': 'CHAT_MESSAGE',
      'chat': {
        'id': chat.id,
        'nome': chat.nome,
        'fornecedor': {
          'nome': chat.supplier.name,
          'logo': chat.supplier.logo,
        },
      }
    };
    pushNotificationFacede.sendMessage(
      devices: tokens ?? [],
      title: 'Nova Mensagem',
      body: model.message,
      payload: payload,
    );
  }

  @override
  Future<List<Chat>> getChatsByUser(int user) =>
      repository.getChatsByUser(user);

  @override
  Future<List<Chat>> getChatsBySupplier(int supplier) =>
      repository.getChatsBySupplier(supplier);

  @override
  Future<void> endChat(int chatId) => repository.endChat(chatId);
}
