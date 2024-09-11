// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/category.dart';
// import 'package:cuidapet_shelf/modules/category/service/i_categories_service_impl.dart';
import 'package:mysql1/mysql1.dart';

import 'i_categories_repository.dart';

@LazySingleton(as: ICategoriesRepository)
class ICategoriesRepositoryImpl implements ICategoriesRepository {
  IDatabaseConnection connection;
  ILogger log;
  ICategoriesRepositoryImpl({
    required this.connection,
    required this.log,
  });
//  MySqlConnection? conn;

//     try {
//       conn = await connection.openConnection();
//     } finally {
//       await conn?.close();
//     }
  @override
  Future<List<Category>> findAll() async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result = await conn.query('select * from categorias_fornecedor');
      if (result.isNotEmpty) {
        return result
            .map((e) => Category(
                id: e['id'],
                name: e['nome_categoria'],
                type: e['tipo_categoria']))
            .toList();
      }
      return [];
    } on MySqlException catch (e, s) {
      log.error("Erro ao BUSCAR as CATEGORIAS do FORNECEDOR", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
