import 'package:cuidapet_shelf/entities/user.dart';

abstract interface class IUserRepository {

  Future <User> createUser(User user);

}