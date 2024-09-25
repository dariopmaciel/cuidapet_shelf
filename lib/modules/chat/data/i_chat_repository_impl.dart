// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/entities/chat.dart';
import 'package:cuidapet_shelf/entities/deviceToken.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:mysql1/mysql1.dart';

import './i_chat_repository.dart';

@LazySingleton(as: IChatRepository)
class IChatRepositoryImpl implements IChatRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  IChatRepositoryImpl({required this.connection, required this.log});

  @override
  Future<int> startChat(int scheduleId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
        INSERT INTO chats(
          agendamento_id,
          status,
          data_criacao)
        VALUES (?,?,?)      
      ''', [
        scheduleId,
        'A',
        DateTime.now().toIso8601String(),
      ]);
      return result.insertId!;
    } on MySqlConnection catch (e, s) {
      log.error('Erro ao iniciar CHAT', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Chat?> findChatById(int chatId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
        SELECT 
          c.id,
			    c.data_criacao,
			    c.status,
          a.nome AS agendamento_nome,
          a.nome_pet AS agendamento_nome_pet,
          a.fornecedor_id,
          a.usuario_id,
          f.nome AS fornec_nome,
          f.logo,
          u.android_token as user_android_token,
          u.ios_token AS user_ios_token
        FROM chats AS c
        INNER JOIN agendamento a ON a.id = c.agendamento_id
        INNER JOIN fornecedor f ON f.id = a.fornecedor_id
        -- Dados do usuario cliente do petshop
        INNER JOIN usuario u ON u.id = a.usuario_id
        -- Dados do usuario fornecedor (O PETSHOP)
        INNER JOIN usuario uf ON uf.fornecedor_id = f.id
        WHERE c.id = ?
      ''', [chatId]);

      if (result.isNotEmpty) {
        final resultMysql = result.first;
        return Chat(
          id: resultMysql['id'],
          status: resultMysql['status'],
          nome: resultMysql['agendamento_nome'],
          petName: resultMysql['agendamento_nome_pet'],
          supplier: Supplier(
            id: resultMysql['fornecedor_id'],
            name: resultMysql['fornec_nome'],
          ),
          user: resultMysql['usuario_id'],
          userDeviceToken: DeviceToken(
            android: (resultMysql['user_android_token'] as Blob?)?.toString(),
            ios: (resultMysql['user_ios_token'] as Blob?)?.toString(),
          ),
          supplierDeviceToken: DeviceToken(
            android: (resultMysql['fornec_android_token'] as Blob?)?.toString(),
            ios: (resultMysql['fornec_ios_token'] as Blob?)?.toString(),
          ),
        );
      }
    } on MySqlConnection catch (e, s) {
      log.error('Erro ao buscar dados do CHAT', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Chat>> getChatsByUser(int user) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final querry = ('''
         SELECT
              c.id,
              c.data_criacao,
              c.status, 
              a.nome,
              a.nome_pet,
              a.fornecedor_id,
              a.usuario_id,
              f.nome as fornec_nome,
              f.logo
            FROM chats as c
            INNER JOIN agendamento a on a.id = c.agendamento_id
            INNER JOIN fornecedor f on f.id = a.fornecedor_id
            WHERE 
              a.usuario_id = ?
            AND
              c.status = 'A'
            ORDER BY c.data_criacao      
      ''');
      final result = await conn.query(querry, [user]);
      return result
          .map(
            (c) => Chat(
              id: c['id'],
              user: c['usuario_id'],
              supplier: Supplier(
                id: c['fornecedor_id'],
                name: c['fornec_nome'],
                logo: (c['logo'] as Blob?)?.toString(),
              ),
              nome: c['nome'],
              petName: c['nome_pet'],
              status: c['status'],
            ),
          )
          .toList();
      // final result = await conn.query('''
      //       SELECT
      //         c.id,
      //         c.data_criacao,
      //         c.status,
      //         a.nome,
      //         a.nome_pet,
      //         a.fornecedor_id,
      //         a.usuario_id,
      //         f.nome as fornec_nome,
      //         f.logo
      //       FROM chats as c
      //       INNER JOIN agendamento a on a.id = c.agendamento_id
      //       INNER JOIN fornecedor f on f.id = a.fornecedor_id
      //       WHERE
      //         a.usuario_id = ?
      //       AND
      //         c.status = 'A'
      //       ORDER BY c.data_criacao
      // ''', [user]);
      // return result
      //     .map(
      //       (c) => Chat(
      //         id: c['id'],
      //         user: c['usuario_id'],
      //         supplier: Supplier(
      //           id: c['fornecedor_id'],
      //           name: c['fornec_nome'],
      //           // logo: (c['logo'] as Blob?)?.toString(),
      //           logo: (c['logo'] != null)
      //               ? (c['logo'] as Blob).toString()
      //               : null, // Corrigido: Tratamento seguro para Blob
      //         ),
      //         nome: c['nome'],
      //         petName: c['nome_pet'],
      //         status: c['status'],
      //       ),
      //     )
      //     .toList();
    } on MySqlConnection catch (e, s) {
      log.error('Erro ao buscar chats de um usuario', e, s);
      // throw DatabaseException();
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
/*
  MySqlConnection? conn;
  try {
    conn = await connection.openConnection();
    final result = await conn.query('''

      
      
    ''',[]);
  } on MySqlConnection catch (e, s) {
    log.error('Erro ao buscar dados do CHAT', e, s);
    throw DatabaseException();
  } finally {
    await conn?.close();
  }
  */
