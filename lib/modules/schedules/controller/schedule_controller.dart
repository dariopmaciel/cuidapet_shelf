// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/modules/schedules/service/i_schedule_service.dart';
import 'package:cuidapet_shelf/modules/schedules/view_models/schedule_save_input_model.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

part 'schedule_controller.g.dart';

@Injectable()
class ScheduleController {
  final IScheduleService service;

  ScheduleController({required this.service});

  @Route.post('/')
  Future<Response> scheduleServices(Request request) async {
    final userId = int.parse(request.headers['user']!);

    final inputModel = ScheduleSaveInputModel(
      userId: userId,
      dataRequest: await request.readAsString(),
    );
    service.scheduleService(inputModel);
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$ScheduleControllerRouter(this);
}
