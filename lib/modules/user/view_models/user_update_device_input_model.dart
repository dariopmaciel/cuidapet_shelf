import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';
import 'package:cuidapet_shelf/modules/user/view_models/platform.dart';

class UserUpdateDeviceInputModel extends RequestMapping {
  int userId;
  late String token;
  late Platform platform;

  UserUpdateDeviceInputModel(
      {required this.userId, required String dataRequest})
      : super(dataRequest);

  @override
  void map() {
    token = data['token'];
    platform = (data['platform'].toLowerCase() == 'ios' ? Platform.ios : Platform.android);
  }
}
