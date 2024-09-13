import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';

abstract interface class ISupplierRepository {
  Future<List<SupplierNearByMeDto>> findNearbyPosition(double lat, double lng, int distance);
  Future<Supplier?> findById(int id);
  Future<List<SupplierServiceS>> findServicesBySupplierId(int supplierId);
  Future<bool> checkUserEmailExists(String email);
  Future <int> saveSupplier (Supplier supplier); //salva o fornecedor
  
}
