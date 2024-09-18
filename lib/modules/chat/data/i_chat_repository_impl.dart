// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/entities/chat.dart';
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
  Future<Chat> findChatById(int chat) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
        
      
      
      ''',[]);
    } on MySqlConnection catch (e, s) {
      log.error('Erro ao iniciar CHAT', e, s);
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



    } on MySqlConnection catch (e, s) {
      log.error('Erro ao iniciar CHAT', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
*/