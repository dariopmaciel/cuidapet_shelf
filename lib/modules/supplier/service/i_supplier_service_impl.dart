// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_shelf/modules/supplier/data/i_supplier_repository.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class ISupplierServiceImpl implements ISupplierService {
  final ISupplierRepository repository;
  // ignore: constant_identifier_names
  static const DISTANCE = 5;
  ISupplierServiceImpl({required this.repository});

  @override
  Future<List<SupplierNearByMeDto>> findNearbyMe(double lat, double lng) =>
      repository.findNearbyPosition(lat, lng, DISTANCE);

  @override
  Future<Supplier?> findById(int id) => repository.findById(id);

  @override
  Future<List<SupplierServiceS>> findServicesBySupplierId(int supplierId) =>
      repository.findServicesBySupplierId(supplierId);

  @override
  Future<bool> checkUserEmailExists(String email) =>repository.checkUserEmailExists(email);
  //
}
