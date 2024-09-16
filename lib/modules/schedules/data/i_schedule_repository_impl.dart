import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/schedule.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_schedule_repository.dart';

@LazySingleton(as: IScheduleRepository)
class IScheduleRepositoryImpl implements IScheduleRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  IScheduleRepositoryImpl({
    required this.connection,
    required this.log,
  });

  @override
  Future<void> save(Schedule schedule) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      await conn.transaction((_) async {
        final result = await conn!.query('''
          INSERT INTO
            agendamento (
              data_agendamento, 
              usuario_id,
              fornecedor_id, 
              status, 
              nome, 
              nome_pet)
            VALUES(?,?,?,?,?,?)
        ''', [
          schedule.scheduleDate.toIso8601String(),
          schedule.userId,
          schedule.supplier.id,
          schedule.status,
          schedule.name,
          schedule.petName,
        ]);
      });
    } on MySqlException catch (e, s) {
      log.error("ERRO AO EFETUAR SAVE", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
