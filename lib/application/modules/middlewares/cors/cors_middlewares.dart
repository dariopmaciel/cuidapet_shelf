import 'dart:io';

import 'package:cuidapet_shelf/application/modules/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';
// import 'package:shelf/src/request.dart';
// import 'package:shelf/src/response.dart';

class CorsMiddlewares extends Middlewares {
  final Map<String, String> headers = {
    //Qual a origem que eu ACEITO RECEBER REQUISIÇÕES somente feito pelo BROWSER, no mobile não é feito
    'Access-Control_Allow-Origin': '*',
    //Quais os são METODOS PERMITIDOS para estas URL
    'Access-Control_Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    //Quais os PARAMETROS que eu aceito receber no meu SERVIDOR
    'Access-Control_Allow-Header':
        '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}',
  };

  @override
  Future<Response> execute(Request request) async {
    //
    print('Iniciando CrossDomain');
    //
    if (request.method == 'OPTIONS') {
      print('Retornando Header do CrossDomain');
      return Response(HttpStatus.ok, headers: headers);
    }
    print('Executando função');
    final response = await innerHandler(request);
    print('Respondendo para o cliente');
    return response.change();
  }
}
