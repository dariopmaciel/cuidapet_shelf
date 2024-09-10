// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_shelf/application/exceptions/user_not_found_exception.dart';
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
        throw UserNotFoundException(message: 'Usuário ou senha inválidos');
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

  @override
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result =
          await conn.query('select * from usuario where email = ?', [email]);
      if (result.isEmpty) {
        throw UserNotFoundException(message: "Usuario não encontrado!");
      } else {
        final dataMySql = result.first;
        if (dataMySql['social_id'] == null ||
            dataMySql['social_id'] != socialKey) {
          await conn.query('''
            update usuario 
            set social_id = ?, tipo_cadastro = ? 
            where id = ? 
            ''', [
            socialKey,
            socialType,
            dataMySql['id'],
          ]);
        }
        return User(
          id: dataMySql['id'] as int,
          email: dataMySql['email'],
          registerType: dataMySql['tipo_cadastro'],
          iosToken: (dataMySql['ios_token'] as Blob?)?.toString(),
          androidToken: (dataMySql['android_token'] as Blob?)?.toString(),
          refreshToken: (dataMySql['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (dataMySql['img_avatar'] as Blob?)?.toString(),
          supplierId: dataMySql['fornecedor_id'],
        );
      }
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUserDeviceTokenAndRefreshToken(User user) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final setParams = {};
      // receber um dos dois tipos de token IOSTOKEN OU ANDROIDTOKEN
      if (user.iosToken != null) {
        //se for acesso por ios
        setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        //se for acessopor android
        setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = '''
        update usuario
        set
          ${setParams.keys.elementAt(0)} = ?,
          refresh_token = ?
        where
          id = ?
      ''';
      await conn.query(query, [
        setParams.values.elementAt(0),
        user.refreshToken!,
        user.id,
      ]);
    } on MySqlException catch (e, s) {
      log.error("Erro ao confirmar login", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateRefreshToken(User user) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();

      await conn.query('update usuario set refresh_token = ? where id = ?', [
        user.refreshToken!,
        user.id!,
      ]);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();

      // conn.query('''
      // select *  form usuario where id = ? ''');

      //OU
      final result = await conn.query('''
        select 
          id, 
          email, 
          tipo_cadastro, 
          ios_token, 
          android_token, 
          refresh_token, 
          img_avatar,       
          fornecedor_id
        from usuario
        where id = ? 
        ''', [id]);
      if (result.isEmpty) {
        log.error("Usuario NÃO encontrado com o ID{$id}");
        throw UserNotFoundException(
            message: "Usuario NÃO encontrado com o ID{$id}");
      } else {
        final dataMySql = result.first;
        return User(
          id: dataMySql['id'] as int,
          email: dataMySql['email'],
          registerType: dataMySql['tipo_cadastro'],
          iosToken: (dataMySql['ios_token'] as Blob?)?.toString(),
          androidToken: (dataMySql['android_token'] as Blob?)?.toString(),
          refreshToken: (dataMySql['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (dataMySql['img_avatar'] as Blob?)?.toString(),
          supplierId: dataMySql['fornecedor_id'],
        );
      }
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUrlAvatar(int id, String urlAvatar) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      await conn.query('update usuario set img_avatar = ? where id = ?', [
        urlAvatar,
        id,
      ]);
    } on MySqlException catch (e, s) {
      log.error("Erro ao atualizar AVATAR", e, s);
      throw DatabaseException(message: "Erro ao atualizar AVATAR");
    } finally {
      await conn?.close();
    }
  }
}
