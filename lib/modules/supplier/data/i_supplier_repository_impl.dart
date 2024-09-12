// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/application/exceptions/database_exception.dart';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/entities/category.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
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
      final result = await conn.query(query);
      return result
          .map(
            (f) => SupplierNearByMeDto(
              id: f['id'],
              name: f['nome'],
              logo: (f['logo'] as Blob?)?.toString(),
              distance: f['distancia'],
              categoryId: f['categorias_fornecedor_id'],
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      log.error("Erro ao buscar Fornecedores perto de mim", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Supplier?> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT
          f.id,
          f.nome,
          f.logo,
          f.endereco,
          f.telefone,
          ST_X(f.latlng) as lat,
          ST_Y(f.latlng) as lng,
          f.categorias_fornecedor_id,
          c.nome_categoria,
          c.tipo_categoria
        FROM fornecedor as f
          inner join categorias_fornecedor as c on (f.categorias_fornecedor_id = c.id)
        WHERE
          f.id = ?
      ''';
      final result = await conn.query(query, [id]);
      if (result.isNotEmpty) {
        final dataMysql = result.first;
        return Supplier(
          id: dataMysql['id'],
          name: dataMysql['nome'],
          logo: (dataMysql['logo'] as Blob?)?.toString(),
          address: dataMysql['endereco'],
          phone: dataMysql['telefone'],
          lat: dataMysql['lat'],
          lng: dataMysql['lng'],
          category: Category(
            id: dataMysql['categorias_fornecedor_id'],
            name: dataMysql['nome_categoria'],
            type: dataMysql['tipo_categoria'],
          ),
        );
      }
    } on MySqlException catch (e, s) {
      log.error("ERRO ao buscar Fornecedor", e, s);
      // throw DatabaseException(message: "ERRO ao buscar Fornecedor");
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
    return null;
  }

  @override
  Future<List<SupplierServiceS>> findServicesBySupplierId(
      int supplierId) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      //
      final result = await conn.query('''
        SELECT 
          id, 
          fornecedor_id, 
          nome_servico, 
          valor_servico
        FROM
          fornecedor_servicos
        WHERE
          fornecedor_id = ?
      ''', [supplierId]);
      if (result.isEmpty) {
        return [];
      }
      return result
          .map((serviceS) => SupplierServiceS(
                id: serviceS['id'],
                supplierId: serviceS['fornecedor_id'],
                name: serviceS['nome_servico'],
                price: serviceS['valor_servico'],
              ))
          .toList();
    } on MySqlException catch (e, s) {
      log.error("ERRO ao buscar os Serviços dos Fornecedores", e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> checkUserEmailExists(String email) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();

      final result = await conn.query('''
        SELECT 
          count(*)
        FROM
          usuario
        WHERE
          email = ?
      ''', [email]);

      final dataMysql =
          result.first; //pega o primeiro item, se maior q zero  True : False
      return dataMysql[0] > 0;
      
    } on MySqlException catch (e, s) {
      log.error("Erro ao verificar EXISTE;", e, s);
      throw DatabaseException();
    } finally {
      conn?.close();
    }
  }
}
