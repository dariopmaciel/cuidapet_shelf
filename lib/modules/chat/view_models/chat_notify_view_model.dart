import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

enum NotificationUserType { user, supplier }

class ChatNotifyViewModel extends RequestMapping {
  late int chat;
  late String message;
  late NotificationUserType notificationUserType;

  // ChatNotifyViewModel(String dataRequest): super(dataRequest);
  ChatNotifyViewModel(super.dataRequest);

  @override
  void map() {
    chat = data['chat'];
    message = data['message'];
    String notificationUserTypeRq = data['to'];
    notificationUserType = notificationUserTypeRq.toLowerCase() == 'u'
        ? NotificationUserType.user
        : NotificationUserType.supplier;
  }
}
