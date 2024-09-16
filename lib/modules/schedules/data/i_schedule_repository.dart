import 'package:cuidapet_shelf/entities/schedule.dart';

abstract interface class IScheduleRepository {

Future<void> save(Schedule schedule);
}