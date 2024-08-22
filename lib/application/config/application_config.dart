import 'package:dotenv/dotenv.dart' show load, env;

class ApplicationConfig {
  Future<void> _loadEnv() async => load();

  Future<void> loadConfigApplication() async {
    await _loadEnv();
    // final variavel = env['url_banco_de_dados'];
    // final flutterHome = env['FLUTTER_HOME'];

    // print(variavel);
    // print(flutterHome);
    _loadDataBaseConfig() {}
  }
}
