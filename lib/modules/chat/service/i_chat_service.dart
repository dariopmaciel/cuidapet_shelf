import 'package:cuidapet_shelf/entities/chat.dart';
import 'package:cuidapet_shelf/modules/chat/view_models/chat_notify_view_model.dart';

abstract interface class IChatService {
  Future<int> startChat(int scheduleId);
  Future<void> notifyChat(ChatNotifyViewModel model);
  Future<List<Chat>> getChatsByUser(int user);
  Future<List<Chat>> getChatsBySupplier(int supplier);
  Future<void> endChat(int chatId);
   
}
