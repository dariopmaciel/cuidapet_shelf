// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cuidapet_shelf/application/helpers/jwt_helper.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import 'package:cuidapet_shelf/application/logger/i_logger.dart';
import 'package:cuidapet_shelf/application/modules/middlewares/middlewares.dart';
import 'package:cuidapet_shelf/application/modules/middlewares/security/security_skip_url.dart';

class SecurityMiddleware extends Middlewares {
  final ILogger log;

  final skipUrl = <SecuritySkipUrl>[
    SecuritySkipUrl(
      url: '/auth/',
      method: 'POST',
    )
  ];

  SecurityMiddleware( this.log);

  @override
  Future<Response> execute(Request request) async {
    try {
      if (skipUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }
//segundo passo
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');
      if (authHeaderContent[0] == "Bearer") {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];

      final claims = JwtHelper.getClaims(authorizationToken);

      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }
      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'];
      final supplierId = claimsMap['supplier'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
        'supplier': supplierId,
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log.error("Erro ao validar Token JWT", e, s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      log.error("Internal Server Error ", e, s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
