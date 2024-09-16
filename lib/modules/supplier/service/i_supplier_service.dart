import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
import 'package:cuidapet_shelf/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_shelf/modules/supplier/view_models/supplier_update_input_model.dart';

abstract interface class ISupplierService {
  Future<List<SupplierNearByMeDto>> findNearbyMe(double lat, double lng);
  Future<Supplier?> findById(int id);
  Future<List<SupplierServiceS>> findServicesBySupplierId(int supplierId);
  Future<bool> checkUserEmailExists(String email);
  Future<void> createUserSupplier(CreateSupplierUserViewModel model);
  Future<Supplier> update(SupplierUpdateInputModel model);
}
