// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/user/controller/auth_controller.dart' as _i477;
import '../../modules/user/data_repository/i_user_repository.dart' as _i694;
import '../../modules/user/data_repository/i_user_repository_impl.dart'
    as _i693;
import '../../modules/user/service/i_user_service.dart' as _i610;
import '../../modules/user/service/i_user_service_impl.dart' as _i705;
import '../database/i_database_connection.dart' as _i77;
import '../logger/i_logger.dart' as _i742;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i477.AuthController>(
        () => _i477.AuthController(userService: gh<_i610.IUserService>()));
    gh.lazySingleton<_i705.IUserServiceImpl>(() =>
        _i705.IUserServiceImpl(userRepository: gh<_i694.IUserRepository>()));
    gh.lazySingleton<_i693.IUserRepositoryImpl>(() => _i693.IUserRepositoryImpl(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    return this;
  }
}
