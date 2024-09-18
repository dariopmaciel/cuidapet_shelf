// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String email;
  late String password;
  int? supplierId;

  UserSaveInputModel({
    required this.email,
    required this.password,
    required this.supplierId,
  }) : super.empty();

  // ignore: non_constant_identifier_names, use_super_parameters
  UserSaveInputModel.RequestMapping(String dataRequest) : super(dataRequest);
  //ou
  // UserSaveInputModel.request(super.dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
