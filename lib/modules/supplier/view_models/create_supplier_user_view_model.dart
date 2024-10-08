import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class CreateSupplierUserViewModel extends RequestMapping {
  late String supplierName;
  late String email;
  late String password;
  late int category;

  CreateSupplierUserViewModel(super.dataRequest);
  // CreateSupplierUserViewModel(String dataRequest): super(dataRequest);

  @override
  void map() {
    supplierName = data['supplier_name'];
    email = data['email'];
    password = data['password'];
    category = data['category_id'];
  }
}
