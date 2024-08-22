import 'package:cuidapet_shelf/application/config/database_connection_configuration.dart';
import 'package:cuidapet_shelf/application/config/service_locator_config.dart';
import 'package:cuidapet_shelf/application/routes/router_configure.dart';

import 'package:dotenv/dotenv.dart' show load, env;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shelf_router/shelf_router.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    await _loadEnv();
    _loadDataBaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfigure(router);
  }

  Future<void> _loadEnv() async => load();

  void _loadDataBaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databeseHost']!,
      user: env['DATABASE_USER'] ?? env['databaseUser']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
      databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
    );
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() => GetIt.I.registerLazySingleton(() => Logger());
  
  void _loadDependencies() =>configureDependencies();
  
  void _loadRoutersConfigure(Router router) =>RouterConfigure(router).configure();
}
