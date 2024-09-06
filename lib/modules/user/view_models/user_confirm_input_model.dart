// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  //inicializados na contrução
  int userId;
  String accessToken;
  //inicializados depois
  late String iosDeviceToken;
  late String androidDeviceToken;
  UserConfirmInputModel(
      {required this.userId, required this.accessToken, required String data})
      : super(data);

  @override
  void map() {
    //
  }
}
