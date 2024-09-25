import 'package:cuidapet_shelf/entities/chat.dart';

abstract interface class IChatRepository {
  Future<int> startChat(int scheduleId);
  Future<Chat?> findChatById(int chatId);
  Future<List<Chat>> getChatsByUser(int user);
  Future<List<Chat>> getChatsBySupplier(int supplier);
}
