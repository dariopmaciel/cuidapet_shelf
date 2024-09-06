// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/application/helpers/request_mapping.dart';

class UserRefreshTokenInputModel extends RequestMapping {
  int user;
  int? supplier;
  String accessToken;
  late String refresToken;

  // UserRefreshTokenInputModel(
  //   super.dataRequest, {
  //   required this.user,
  //   this.supplier,
  //   required this.accessToken,
  //   required this.refresToken,
  // });

  UserRefreshTokenInputModel({
    required this.user,
    this.supplier,
    required this.accessToken,
    required String dataRequest,
  }) : super(dataRequest);

  @override
  void map() {
    refresToken = data['refresh_token'];
  }
}
