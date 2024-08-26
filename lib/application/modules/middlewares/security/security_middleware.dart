// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:shelf/src/request.dart';
// import 'package:shelf/src/response.dart';

// import 'package:cuidapet_shelf/application/logger/i_logger.dart';
// import 'package:cuidapet_shelf/application/modules/middlewares/middlewares.dart';
// import 'package:cuidapet_shelf/application/modules/middlewares/security/security_skip_url.dart';

// class SecurityMiddleware extends Middlewares {
//   final ILogger log;
//   final skypUrl = <SecuritySkipUrl>[];

//   SecurityMiddleware({required this.log});

  // @override
  // Future<Response> execute(Request request) async {
  //   if (skypUrl.contains(
  //       SecuritySkipUrl(url: '/${request.url.path}', method: request.method))) {
  //     return innerHandler(request);
  //   }
  //   final authHeader = request.headers['Authorization'];
  //   if (authHeader ==null|| authHeader.isEmpty) {
  //     return Response.forbidden(jsonEncode({}));
  //   }
  // }
// }
