import 'package:cuidapet_shelf/entities/chat.dart';

abstract interface class IChatRepository {
  Future<int> startChat(int scheduleId);
  Future<Chat> findChatById(int chat);
}
