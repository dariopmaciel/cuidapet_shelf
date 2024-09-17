import 'package:cuidapet_shelf/entities/schedule.dart';

abstract interface class IScheduleRepository {
  Future<void> save(Schedule schedule);

  Future<void> changeStatus(String status, int scheduleId);

  Future<List<Schedule>> findAllScheduleByUser(int userId);

  Future<List<Schedule>> findAllScheduleByUserSupplier(int userId);
}
