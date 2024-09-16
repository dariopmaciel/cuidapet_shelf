// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';
import 'package:cuidapet_shelf/entities/category.dart';

class SupplierUpdateInputModel extends RequestMapping {
  int supplierId;
  late String name;
  late String logo;
  late String address;
  late String phone;
  late double lat;
  late double lng;
  late Category categoryId;

  // SupplierUpdateInputModel(
  //   super.dataRequest, {
  //   required this.supplierId,
  //   required this.name,
  //   required this.logo,
  //   required this.address,
  //   required this.phone,
  //   required this.lat,
  //   required this.lng,
  //   required this.categoryId,
  // });

  SupplierUpdateInputModel(
      {required this.supplierId, required String dataRequest})
      : super(dataRequest);

  @override
  void map() {
    name = data['name'];
    logo = data['logo'];
    address = data['address'];
    phone = data['phone'];
    lat = data['lat'];
    lng = data['lng'];
    categoryId = data['category'];
  }
}
