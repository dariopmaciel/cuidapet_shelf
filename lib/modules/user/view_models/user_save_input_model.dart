import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String email;
  late String password;
  int? supplierId;

  UserSaveInputModel(super.dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
