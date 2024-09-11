import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';

abstract interface class ISupplierRepository {
  Future<List<SupplierNearByMeDto>> findNearbyPosition(double lat, double lng, int distance);
  Future<Supplier?> findById(int id);
}
