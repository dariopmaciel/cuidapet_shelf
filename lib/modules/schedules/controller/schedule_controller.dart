// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/modules/schedules/service/i_schedule_service.dart';
import 'package:cuidapet_shelf/modules/schedules/view_models/schedule_save_input_model.dart';
import 'package:cuidapet_shelf/modules/user/view_models/user_save_input_model.dart';

part 'schedule_controller.g.dart';

@Injectable()
class ScheduleController {
  final IScheduleService service;
  final ILogger log;

  ScheduleController({
    required this.service,
    required this.log,
  });

  @Route.post('/')
  Future<Response> scheduleServices(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);

      final inputModel = ScheduleSaveInputModel(
        userId: userId,
        dataRequest: await request.readAsString(),
      );
      await service.scheduleService(inputModel);
      return Response.ok(jsonEncode(''));
    } catch (e, s) {
      log.error("ERRO AO SALVAR AGENDAMENTO", e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$ScheduleControllerRouter(this);
}
