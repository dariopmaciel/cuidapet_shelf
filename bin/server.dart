//dart create -t server-shelf ./nome_projeto
import 'dart:io';
import 'package:cuidapet_shelf/application/config/application_config.dart';
import 'package:cuidapet_shelf/application/middlewares/cors/cors_middlewares.dart';
import 'package:cuidapet_shelf/application/middlewares/default_content_type/default_content_type.dart';
import 'package:cuidapet_shelf/application/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
// final _router = Router()
//   ..get('/', _rootHandler)
//   ..get('/echo/<message>', _echoHandler);

// Response _rootHandler(Request req) {
//   return Response.ok('Hello, Worrrrrld!\n');
// }

// Response _echoHandler(Request request) {
//   final message = request.params['message'];
//   return Response.ok('$message\n');
// }

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final hostname =  InternetAddress.anyIPv4;

//Application Config
  final router = Router(); //config do server router, instancia o router
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);


final getIt = GetIt.I;
  final handler = Pipeline()
      // .addMiddleware((innerHandler) {
      //   print("MIDDLEWARE 1 INICIANDO");
      //   return (Request request) async {
      //     print("MIDDLEWARE 1 FUNÇÃO INTERNA");
      //     //mensagem intermediária de middleware bloqueando a função
      //     return Response.ok("DAQUI NÃO PASSA NINGUEM",
      //         headers: {'content-type': 'application/json'}); //abaixo deadcode
      //     // final resp = await innerHandler(request);
      //     // print("FINALIZANDO MIDDLEWARE 1 FUNÇÃO INTERNA");
      //     // return resp;
      //   };
      // })
      // .addMiddleware((innerHandler) {
      //   print("MIDDLEWARE 2 INICIANDO");
      //   return (Request request) async {
      //     print("MIDDLEWARE 2 FUNÇÃO INTERNA");
      //     final resp = await innerHandler(request);
      //     print("FINALIZANDO MIDDLEWARE 2 FUNÇÃO INTERNA");
      //     return resp;
      //   };
      // })
      //
      //Cors = CrossDomain (ligação entre dominios diferentes)
      .addMiddleware(CorsMiddlewares().handler)
      // .addMiddleware(DefaultContentType().handler)
      //ambas as formas estão corretas
      //passa por parametro
      //abaixo formatador
      .addMiddleware(DefaultContentType('application/json;charset=utf-8').handler)
      .addMiddleware(SecurityMiddleware(getIt.get()).handler)
      .addMiddleware(logRequests())
      .addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080'); //8093

  final server = await serve(handler, hostname, port);
  
  print('Server listening on port ${server.address.host}: ${server.port}');
}


/*
Um "projeto shelf" em Flutter refere-se ao uso da biblioteca Shelf, que é uma biblioteca do ecossistema Dart usada principalmente para construir servidores HTTP modulares e eficientes. Embora o Flutter seja focado no desenvolvimento de interfaces gráficas para dispositivos móveis, a linguagem Dart, que é usada para programar em Flutter, também pode ser utilizada para criar servidores backend, e é aí que a biblioteca Shelf entra em ação.

O que é a biblioteca Shelf?
A Shelf é uma coleção de utilitários para criar servidores HTTP, APIs REST e middlewares em Dart. Ela permite criar facilmente servidores HTTP modulares, onde é possível adicionar ou remover componentes como middlewares para tratamento de requisições e respostas.

Usos Comuns da Biblioteca Shelf:
Servidores HTTP Simples: Permite criar um servidor HTTP simples que pode servir arquivos estáticos, como páginas HTML, CSS e JavaScript.
APIs REST: A Shelf é amplamente usada para construir APIs RESTful.
Middleware: Com Shelf, é possível criar middlewares que interceptam as requisições HTTP para adicionar funcionalidades como autenticação, manipulação de cabeçalhos, entre outros.
Por que usar Shelf com Flutter?
Embora o Flutter seja usado para desenvolvimento frontend (aplicativos móveis, desktop e web), existem casos em que você pode querer que o backend da aplicação também seja desenvolvido em Dart para manter a uniformidade no projeto. Um "projeto Shelf" em Flutter pode ser usado para:

Desenvolver uma API Backend: Você pode usar Dart e Shelf para construir a API backend da sua aplicação Flutter, mantendo todo o código no mesmo ecossistema.
Servir o Flutter Web: Se estiver desenvolvendo uma aplicação Flutter para web, você pode usar a Shelf para servir os arquivos estáticos gerados pelo Flutter.
Microserviços: Shelf é uma boa opção para a construção de microserviços leves em Dart, que podem ser utilizados em conjunto com aplicações Flutter.
Exemplo Básico de Uso da Shelf:
dart


// **************************************
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  Define uma função handler simples que retorna "Hello, World!" para cada requisição
  final handler = Pipeline().addMiddleware(logRequests()).addHandler((Request request) {
    return Response.ok('Hello, World!');
  });

  Cria um servidor HTTP na porta 8080
  final server = await shelf_io.serve(handler, 'localhost', 8080);

  print('Servidor rodando em http://${server.address.host}:${server.port}');
}

// **************************************
Nesse exemplo simples, o servidor criado responde com "Hello, World!" a todas as requisições HTTP.

Conclusão
Um projeto Shelf em Flutter geralmente se refere à integração de uma aplicação Flutter com um backend em Dart utilizando a biblioteca Shelf. Ele permite que desenvolvedores Flutter usem Dart tanto no frontend quanto no backend, criando uma solução unificada e simplificada para desenvolvimento de aplicativos móveis ou web e seus respectivos backends.

*/