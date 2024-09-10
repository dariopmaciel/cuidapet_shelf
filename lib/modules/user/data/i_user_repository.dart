

import 'package:cuidapet_shelf/entities/user.dart';
import 'package:cuidapet_shelf/modules/user/view_models/platform.dart';

//acesso ao banco de dados
abstract interface class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithUserEmailPassword(
      String email, String password, bool supplierUser);
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType);
  Future<void> updateUserDeviceTokenAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
  Future<void> updateUrlAvatar(int id, String urlAvatar);
  Future<void> updateDeviceToken(int id, String token, Platform platform);
}
