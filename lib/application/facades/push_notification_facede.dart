// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class PushNotificationFacede {
  final ILogger log;
  PushNotificationFacede({required this.log});

  Future<void> sendMessage({
    required List<String?> devices,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    //! MINUTO 6:50 CRIAÇÃO NO POSTMAN
    //* MINUTO 6:50 CRIAÇÃO NO POSTMAN
    try {
      final request = {
        'notification': {
          'body': body,
          'title': title,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'payload': payload
        }
      };
      //! Isto será direcionado para o ENV!
      final firebaseKey = env['FIREBASE_PUSH_KEY'] ?? env['firebasePushKey'];

      if (firebaseKey == null) {
        return; //estrategia para parar o processo
      }

      for (var device in devices) {
        if (device != null) {
          request['to'] = device;
          log.info('Enviando mensagem para $device');
          final result = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'), //!será isto????
            // await http.post(Uri.parse('ADD URL DO POSTMAN'),
            body: jsonEncode(request),
            headers: {
              //criar variavel e jogar para o ENV
              'Authorization': 'key=$firebaseKey',
              'Content-Type': 'application/json',
            },
          );
          final responseData = jsonDecode(result.body);
          if (responseData['failure'] == 1) {
            log.error(
                "Erro ao enviar notificação $device erro: ${responseData['results']?['error']}");
          } else {
            log.info("Notificação enviada com sucesso $device");
          }
        }
      }
    } catch (e, s) {
      log.error('Erro ao enviar notificação', e, s);
    }
  }
}
