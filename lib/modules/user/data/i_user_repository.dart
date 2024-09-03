import 'package:cuidapet_shelf/entities/user.dart';

//acesso ao banco de dados
abstract interface class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithUserEmailPassword(String email, String password, bool supplierUser);
}
