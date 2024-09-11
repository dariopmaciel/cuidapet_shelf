// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/category/controller/categories_controller.dart' as _i400;
import '../../modules/category/data/i_categories_repository.dart' as _i57;
import '../../modules/category/data/i_categories_repository_impl.dart' as _i724;
import '../../modules/category/service/i_categories_service.dart' as _i967;
import '../../modules/category/service/i_categories_service_impl.dart' as _i191;
import '../../modules/supplier/data/i_supplier_repository.dart' as _i417;
import '../../modules/supplier/data/i_supplier_repository_impl.dart' as _i566;
import '../../modules/supplier/service/i_supplier_service.dart' as _i448;
import '../../modules/supplier/service/i_supplier_service_impl.dart' as _i293;
import '../../modules/user/controller/auth_controller.dart' as _i477;
import '../../modules/user/controller/user_controller.dart' as _i983;
import '../../modules/user/data/i_user_repository.dart' as _i872;
import '../../modules/user/data/i_user_repository_impl.dart' as _i1014;
import '../../modules/user/service/i_user_service.dart' as _i610;
import '../../modules/user/service/i_user_service_impl.dart' as _i705;
import '../database/i_database_connection.dart' as _i77;
import '../database/i_database_connection_impl.dart' as _i795;
import '../logger/i_logger.dart' as _i742;
import 'database_connection_configuration.dart' as _i32;

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
    gh.lazySingleton<_i448.ISupplierService>(
        () => _i293.ISupplierServiceImpl());
    gh.lazySingleton<_i417.ISupplierRepository>(
        () => _i566.ISupplierRepositoryImpl());
    gh.factory<_i77.IDatabaseConnection>(() => _i795.IDatabaseConnectionImpl(
        gh<_i32.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i872.IUserRepository>(() => _i1014.IUserRepositoryImpl(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i57.ICategoriesRepository>(
        () => _i724.ICategoriesRepositoryImpl(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    gh.lazySingleton<_i610.IUserService>(() => _i705.IUserServiceImpl(
          log: gh<_i742.ILogger>(),
          userRepository: gh<_i872.IUserRepository>(),
        ));
    gh.factory<_i477.AuthController>(() => _i477.AuthController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i983.UserController>(() => _i983.UserController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i967.ICategoriesService>(() =>
        _i191.ICategoriesServiceImpl(
            repository: gh<_i57.ICategoriesRepository>()));
    gh.factory<_i400.CategoriesController>(() =>
        _i400.CategoriesController(service: gh<_i967.ICategoriesService>()));
    return this;
  }
}
