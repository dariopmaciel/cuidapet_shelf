import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';

abstract interface class ISupplierService {
Future<List<SupplierNearByMeDto>> findNearbyMe(double lat, double lng, );
}