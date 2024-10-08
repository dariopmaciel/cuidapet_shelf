import 'package:cuidapet_shelf/application/config/database_connection_configuration.dart';
import 'package:injectable/injectable.dart';

import 'package:mysql1/mysql1.dart';

import './i_database_connection.dart';
//CLASSSE DE CONEXÃO
@Injectable(as: IDatabaseConnection)
class IDatabaseConnectionImpl extends IDatabaseConnection {
  //
  final DatabaseConnectionConfiguration _configuration;

  IDatabaseConnectionImpl(this._configuration);

  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(
      ConnectionSettings(
        host: _configuration.host,
        port: _configuration.port,
        user: _configuration.user,
        password: _configuration.password,
        db: _configuration.databaseName,
      ),
    );
  }
}
