// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/application/database/i_database_connection.dart';
import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:mysql1/mysql1.dart';

import './i_supplier_repository.dart';

@LazySingleton(as: ISupplierRepository)
class ISupplierRepositoryImpl implements ISupplierRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  ISupplierRepositoryImpl({required this.connection, required this.log});

  @override
  Future<List<SupplierNearByMeDto>> findNearbyPosition(
      double lat, double lng, int distance) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      
      //!QUERY DO INFERRRRRRRRNO
      final query = '''
        SELECT f.id, f.nome, f.logo, f.categorias_fornecedor_id,
          (6371 * 
            acos(
                  cos(radians($lat)) * 
                  cos(radians(ST_X(f.latlng))) * 
                  cos(radians($lng) - radians(ST_Y(f.latlng))) + 
                  sin(radians($lat)) * 
                  sin(radians(ST_X(f.latlng)))
              )) AS distancia 
              FROM fornecedor f 
          HAVING distancia <= $distance;
        ''';
        
    } on MySqlException catch (e, s) {
      log.error("Erro ao buscar Fornecedores perto de mim", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
