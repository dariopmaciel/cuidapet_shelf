import 'package:cuidapet_shelf/modules/chat/view_models/chat_notify_view_model.dart';

abstract interface class IChatService {
  Future<int> startChat(int scheduleId);
  Future<void> notifyChat(ChatNotifyViewModel model);
}
