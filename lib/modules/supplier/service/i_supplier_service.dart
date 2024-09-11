import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';

abstract interface class ISupplierService {
Future<List<SupplierNearByMeDto>> findNearbyMe(double lat, double lng, );
Future <Supplier?> findById(int id);
}