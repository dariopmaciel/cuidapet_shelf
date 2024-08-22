import 'package:cuidapet_shelf/application/config/database_connection_configuration.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:get_it/get_it.dart';

class ApplicationConfig {
  Future<void> _loadEnv() async => load();

  Future<void> loadConfigApplication() async {
    await _loadEnv();
    // final variavel = env['url_banco_de_dados'];
    // final flutterHome = env['FLUTTER_HOME'];

    // print(variavel);
    // print(flutterHome);
    _loadDataBaseConfig() {
      final databaseConfig = DatabaseConnectionConfiguration(
        host: env['DATABASE_HOST'] ?? env['databeseHost']!,
        user: env['DATABASE_USER'] ?? env['databaseUser']!,
        port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
        password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
        databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
      );
      GetIt.I.registerSingleton(databaseConfig);
    }
  }
}
