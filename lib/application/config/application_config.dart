import 'package:cuidapet_shelf/application/config/database_connection_configuration.dart';
import 'package:cuidapet_shelf/application/config/service_locator_config.dart';

import 'package:dotenv/dotenv.dart' show load, env;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication() async {
    await _loadEnv();
    _loadDataBaseConfig();
    _configLogger();
    _loadDependencies();
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

  void _loadDependencies() => configureDependencies();
}
