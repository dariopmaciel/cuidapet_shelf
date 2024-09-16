// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/modules/supplier/view_models/supplier_update_input_model.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/entities/category.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
import 'package:cuidapet_shelf/modules/supplier/data/i_supplier_repository.dart';
import 'package:cuidapet_shelf/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_shelf/modules/user/service/i_user_service.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class ISupplierServiceImpl implements ISupplierService {
  final ISupplierRepository repository;
  final IUserService userService;

  static const DISTANCE = 5;

  ISupplierServiceImpl({
    required this.repository,
    required this.userService,
  });

  @override
  Future<List<SupplierNearByMeDto>> findNearbyMe(double lat, double lng) =>
      repository.findNearbyPosition(lat, lng, DISTANCE);

  @override
  Future<Supplier?> findById(int id) => repository.findById(id);

  @override
  Future<List<SupplierServiceS>> findServicesBySupplierId(int supplierId) =>
      repository.findServicesBySupplierId(supplierId);

  @override
  Future<bool> checkUserEmailExists(String email) =>
      repository.checkUserEmailExists(email);

  @override
  Future<void> createUserSupplier(CreateSupplierUserViewModel model) async {
    final supplierEntity = Supplier(
        name: model.supplierName, category: Category(id: model.category));

    final supplierId = await repository.saveSupplier(supplierEntity);

    final userInputModel = UserSaveInputModel(
      email: model.email,
      password: model.password,
      supplierId: supplierId,
    );

    await userService.createUser(userInputModel);
  }

  @override
  Future<Supplier> update(SupplierUpdateInputModel model) async {
    var supplier = repository.update(
      Supplier(
          id: model.supplierId,
          name: model.name,
          address: model.address,
          lat: model.lat,
          lng: model.lng,
          logo: model.logo,
          phone: model.phone,
          category: Category(id: model.categoryId)),
    );
    // return await supplier;
    return await repository.update(supplier as Supplier);
  }
}
