

import 'package:cuidapet_shelf/entities/schedule.dart';
import 'package:cuidapet_shelf/modules/schedules/view_models/schedule_save_input_model.dart';

abstract interface class IScheduleService {
Future<void> scheduleService(ScheduleSaveInputModel model);
Future <void> changeStatus(String status, int scheduleId );
Future <List<Schedule>> findAllSchedulesByUser (int userId);
}