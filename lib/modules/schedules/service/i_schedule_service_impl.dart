// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/entities/schedule.dart';
import 'package:cuidapet_shelf/entities/schedule_supplier_service.dart';
import 'package:cuidapet_shelf/entities/supplier.dart';
import 'package:cuidapet_shelf/entities/supplier_service.dart';
import 'package:cuidapet_shelf/modules/schedules/data/i_schedule_repository.dart';
import 'package:cuidapet_shelf/modules/schedules/view_models/schedule_save_input_model.dart';

import './i_schedule_service.dart';

@LazySingleton(as: IScheduleService)
class IScheduleServiceImpl implements IScheduleService {
  IScheduleRepository repository;
  
  IScheduleServiceImpl({required this.repository});

  @override
  Future<void> scheduleService(ScheduleSaveInputModel model) async {
    final schedule = Schedule(
      scheduleDate: model.scheduleDate,
      name: model.name,
      petName: model.petName,
      supplier: Supplier(id: model.supplierId),
      status: 'P',
      userId: model.userId,
      services: model.services
          .map((e) => ScheduleSupplierService(service: SupplierServiceS(id: e)))
          .toList(),
    );
    await repository.save(schedule);
  }
}
