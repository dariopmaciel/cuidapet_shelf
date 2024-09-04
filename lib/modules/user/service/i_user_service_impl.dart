// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/application/exceptions/user_not_found_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/user.dart';
import 'package:cuidapet_shelf/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

import './i_user_service.dart';

//service recebe um input model e convert para entidade
//pega dados converte para entidade e converte para repository...SO ISTO

@LazySingleton(as: IUserService)
class IUserServiceImpl implements IUserService {
  ILogger log;
  IUserRepository userRepository;

  IUserServiceImpl({
    required this.log,
    required this.userRepository,
  });

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

  @override
  Future<User> loginWithSocial(
      String email, String avatar, String socialType, String socialKey) async {
    try {
      // await userRepository.loginByEmailSocialKey(email, socialKey, socialType);
      return await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);
    } on UserNotFoundException catch (e) {
      log.error('Usuario não encontrado, criando um usuario', e);
      final user = User(
        email: email,
        imageAvatar: avatar,
        registerType: socialType,
        socialKey: socialKey,
        password: DateTime.now().toString(),
      );
      // final usuario_criado = await userRepository.createUser(user);
      // return usuario_criado;
      //ou
      return await userRepository.createUser(user);
    }
  }
}
