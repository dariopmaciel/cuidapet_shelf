import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/schedule.dart';
import 'package:cuidapet_shelf/entities/schedule_supplier_service.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
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
        final scheduleId = result.insertId;

        //POR NÃO SER UMA QUERY PADRÃO IRÁ MUDAR
        if (scheduleId != null) {
          // final resultServide = conn.query(
          // final resultServide = conn.queryMulti(
          await conn.queryMulti(
              '''
            INSERT INTO
              agendamento_servicos
            VALUES(?,?)
            ''',
              // [scheduleId, schedule.services]);
              schedule.services.map((s) => [scheduleId, s.service.id]));
        }
      });
    } on MySqlException catch (e, s) {
      log.error("ERRO AO EFETUAR SAVE", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> changeStatus(String status, int scheduleId) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      await conn.query('''
        UPDATE agendamento 
        SET status = ?
        WHERE id = ?
        ''', [status, scheduleId]);
    } on DatabaseException catch (e, s) {
      log.error('Erro ao alterar status de um agendamento', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Schedule>> findAllScheduleByUser(int userId) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT 
          a.id ,
          a.data_agendamento,
          a.status,
          a.nome,
          a.nome_pet,
          f.id as fornec_id,
          f.nome as fornec_nome,
          f.logo 
        FROM agendamento a
        INNER JOIN fornecedor f ON f.id = a.fornecedor_id
        WHERE a.usuario_id = ?
        order by a.data_agendamento desc
      ''';
      final result = await conn.query(query, [userId]);
      final scheduleResultFuture = result
          .map(
            (s) async => Schedule(
              id: s['id'],
              scheduleDate: s['data_agendamento'],
              status: s['status'],
              name: s['nome'],
              petName: s['nome_pet'],
              userId: userId,
              supplier: Supplier(
                id: s['fornec_id'],
                logo: (s['logo'] as Blob?).toString(),
                name: s['fornec_nome'],
              ),
              services: await findAllServicesBySchedule(s['id']),
            ),
          )
          .toList();
      //RESPONSAVEL POR ESPERAR TODOS OS RESULTADOS E RTETORNAR EM UMA LISTA SIMPLES
      // final scheduleResult = Future.wait(scheduleResultFuture);
      // return scheduleResult;
      //ou assim para clean code
      return Future.wait(scheduleResultFuture);
    } on DatabaseException catch (e, s) {
      log.error('Erro ao alterar status de um agendamento', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  Future<List<ScheduleSupplierService>> findAllServicesBySchedule(
      int scheduleId) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
      SELECT 
        fs.id, 
        fs.nome_servico, 
        fs.valor_servico, 
        fs.fornecedor_id
      FROM agendamento_servicos AS ags
      INNER JOIN fornecedor_servicos fs ON fs.id = ags.fornecedor_servicos_id     
      WHERE ags.agendamento_id = ? 
      ''', [scheduleId]);

      return result
          .map(
            (s) => ScheduleSupplierService(
              service: SupplierServiceS(
                id: s['id'],
                name: s['nome_servico'],
                price: s['valor_servico'],
                supplierId: s['fornecedor_id'],
              ),
            ),
          )
          .toList();
    } on DatabaseException catch (e, s) {
      log.error('ERRO AO BUSCAR OS SERVICOS DE UM AGENDAMENTO', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
  
  

  @override
  Future<List<Schedule>> findAllScheduleByUserSupplier(int userId) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT
          a.id ,
          a.data_agendamento,
          a.status,
          a.nome,
          a.nome_pet,
          f.id as fornec_id,
          f.nome as fornec_nome,
          f.logo
        FROM agendamento a
          INNER JOIN fornecedor f ON f.id = a.fornecedor_id
          INNER JOIN usuario u ON u.fornecedor_id = f.id
        WHERE u.id = ?
        order by a.data_agendamento desc
      ''';
      final result = await conn.query(query, [userId]);
      final scheduleResultFuture = result
          .map((s) async => Schedule(
              id: s['id'],
              scheduleDate: s['data_agendamento'],
              status: s['status'],
              name: s['nome'],
              petName: s['nome_pet'],
              userId: userId,
              supplier: Supplier(
                id: s['fornec_id'],
                logo: (s['logo'] as Blob?).toString(),
                name: s['fornec_nome'],
              ),
              services: await findAllServicesBySchedule(s['id'])))
          .toList();
      //RESPONSAVEL POR ESPERAR TODOS OS RESULTADOS E RTETORNAR EM UMA LISTA SIMPLES
      final scheduleResult = Future.wait(scheduleResultFuture);
      return scheduleResult;
      //ou assim para clean code
      // return Future.wait(scheduleResultFuture);
    } on DatabaseException catch (e, s) {
      log.error('Erro ao alterar status de um agendamento', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
