// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_shelf/application/helpers/cripty_helper.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/user.dart';
import 'package:injectable/injectable.dart';

import 'package:mysql1/mysql1.dart';

import 'i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class IUserRepositoryImpl implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  IUserRepositoryImpl({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    late final MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
          insert usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
          values(?,?,?,?,?,?,)
      ''';

      // final result = await conn.query(query, <Object?>[ //quando null-safety
      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        // 'senha', //necessário criptografia , VEJA HELPERS
        CriptyHelper.generateSha256Hash(user.password ?? ''),
        user.supplierId,
        user.socialKey,
      ]);

      final userId = result.insertId;
      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Email já cadastrado na BASE DE DADOS', e, s);
        throw UserExistsException();
      }
      log.error("Erro ao criar usuario", e, s);
      throw DatabaseException(message: 'Erro ao crias usuário', exception: e);
    } finally {
      await conn?.close();
    }
  }
}
