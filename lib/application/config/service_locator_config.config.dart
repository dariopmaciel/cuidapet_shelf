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
import '../../modules/user/data_repository/i_user_repository_impl.dart' as _i1014;
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
    gh.factory<_i477.AuthController>(() => _i477.AuthController());
    gh.lazySingleton<_i1014.IUserRepositoryImpl>(
        () => _i1014.IUserRepositoryImpl(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    return this;
  }
}
