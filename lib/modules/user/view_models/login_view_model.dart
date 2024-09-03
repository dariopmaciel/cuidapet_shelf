import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String login;
  late String password;
  late bool socialLogin;

  LoginViewModel(super.dataRequest);

  @override
  void map() {
    login = data['login'];
    password = data['password'];
    socialLogin = data['social_login'];
    
  }
}
