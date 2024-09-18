// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_shelf/entities/deviceToken.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';

class Chat {
  final int id;
  final int user;
  final Supplier supplier;
  final String nome;
  final String petName;
  final String status;
  final DeviceToken? userDevicetoken;
  final DeviceToken? supplierDevice;
  
  Chat({
    required this.id,
    required this.user,
    required this.supplier,
    required this.nome,
    required this.petName,
    required this.status,
    this.userDevicetoken,
    this.supplierDevice,
  });
}
