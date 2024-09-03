// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/entities/user.dart';
import 'package:cuidapet_shelf/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_user_service.dart';

//service recebe um input model e convert para entidade
//pega dados converte para entidade e converte para repository...SO ISTO

@LazySingleton(as: IUserService)
class IUserServiceImpl implements IUserService {
  IUserRepository userRepository;

  IUserServiceImpl({required this.userRepository});

//objeto de transferencia de camadas
  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'APP',
      supplierId: user.supplierId,
    );
    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithUserEmailPassword(
          String email, String password, bool supplierUser) =>
      userRepository.loginWithUserEmailPassword(email, password, supplierUser);
}
