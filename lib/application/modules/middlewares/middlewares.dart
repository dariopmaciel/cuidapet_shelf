//METODOS IMPLEMENTADOS = CLASSE ABSTRATA = extends
//SE NÃO TEM MÉTODOS IMPLEMENTADOS = É UMA INTERFACE = CONTRATO = implements

//casca de todo o middleware

import 'package:shelf/shelf.dart';

abstract class Middlewares {
  late Handler innerHandler;
  Handler handler(Handler innerHandler) {
    this.innerHandler = innerHandler;
    return execute;
  }

  Future<Response> execute(Request request);
}
