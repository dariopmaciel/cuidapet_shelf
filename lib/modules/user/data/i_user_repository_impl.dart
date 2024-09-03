// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_shelf/application/exceptions/user_not_found_exception%20copy.dart';
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
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
          insert usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
          values(?,?,?,?,?,?)
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

  @override
  Future<User> loginWithUserEmailPassword(
      String email, String password, bool supplierUser) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var query = '''
        select * 
        from usuario
        where 
        email = ? and 
        senha = ?
      ''';
      // if (supplierUser) {
      if (supplierUser == true) {
        query += 'and fornecedor_id is not null';
      } else {
        query += 'and fornecedor_id is null';
      }
      final result = await conn.query(query, [
        email,
        CriptyHelper.generateSha256Hash(password), //cryptografado
      ]);

      if (result.isEmpty) {
        log.error("Usuario ou senha INVÁLIDOS");
        throw UserNotFoundExceptionCopy(message: 'Usuário ou senha inválidos');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?)?.toString(),
          supplierId: userSqlData['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error("Erro ao realizar login", e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }
}
