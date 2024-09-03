import 'package:cuidapet_shelf/entities/user.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

//
abstract interface class IUserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> loginWithUserEmailPassword(String email, String password, bool supplierUser);
  
}
