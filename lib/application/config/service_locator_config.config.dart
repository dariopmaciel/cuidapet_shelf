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
import '../../modules/chat/controller/chat_controller.dart' as _i194;
import '../../modules/chat/data/i_chat_repository.dart' as _i216;
import '../../modules/chat/data/i_chat_repository_impl.dart' as _i697;
import '../../modules/chat/service/i_chat_service.dart' as _i189;
import '../../modules/chat/service/i_chat_service_impl.dart' as _i989;
import '../../modules/schedules/controller/schedule_controller.dart' as _i436;
import '../../modules/schedules/data/i_schedule_repository.dart' as _i411;
import '../../modules/schedules/data/i_schedule_repository_impl.dart' as _i171;
import '../../modules/schedules/service/i_schedule_service.dart' as _i701;
import '../../modules/schedules/service/i_schedule_service_impl.dart' as _i939;
import '../../modules/supplier/controller/supplier_controller.dart' as _i331;
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
    gh.factory<_i77.IDatabaseConnection>(() => _i795.IDatabaseConnectionImpl(
        gh<_i32.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i872.IUserRepository>(() => _i1014.IUserRepositoryImpl(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i417.ISupplierRepository>(
        () => _i566.ISupplierRepositoryImpl(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    gh.lazySingleton<_i216.IChatRepository>(() => _i697.IChatRepositoryImpl(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i57.ICategoriesRepository>(
        () => _i724.ICategoriesRepositoryImpl(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    gh.lazySingleton<_i189.IChatService>(
        () => _i989.IChatServiceImpl(repository: gh<_i216.IChatRepository>()));
    gh.lazySingleton<_i610.IUserService>(() => _i705.IUserServiceImpl(
          log: gh<_i742.ILogger>(),
          userRepository: gh<_i872.IUserRepository>(),
        ));
    gh.lazySingleton<_i448.ISupplierService>(() => _i293.ISupplierServiceImpl(
          repository: gh<_i417.ISupplierRepository>(),
          userService: gh<_i610.IUserService>(),
        ));
    gh.factory<_i477.AuthController>(() => _i477.AuthController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i983.UserController>(() => _i983.UserController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i194.ChatController>(() => _i194.ChatController(
          service: gh<_i189.IChatService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i967.ICategoriesService>(() =>
        _i191.ICategoriesServiceImpl(
            repository: gh<_i57.ICategoriesRepository>()));
    gh.lazySingleton<_i411.IScheduleRepository>(
        () => _i171.IScheduleRepositoryImpl(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    gh.factory<_i331.SupplierController>(() => _i331.SupplierController(
          service: gh<_i448.ISupplierService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i400.CategoriesController>(() =>
        _i400.CategoriesController(service: gh<_i967.ICategoriesService>()));
    gh.lazySingleton<_i701.IScheduleService>(() => _i939.IScheduleServiceImpl(
        repository: gh<_i411.IScheduleRepository>()));
    gh.factory<_i436.ScheduleController>(() => _i436.ScheduleController(
          service: gh<_i701.IScheduleService>(),
          log: gh<_i742.ILogger>(),
        ));
    return this;
  }
}
