import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  JwtHelper._();

  static String generateJWT(int userId, int? supplierId) {
    final claimSet = JwtClaim(
      issuer: 'cuidapet',
      subject: userId.toString(),
      expiry: DateTime.now().add(Duration(days: 1)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{'supplier': supplierId},
      maxAge: Duration(days: 1),
    );
    // final token = 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
    // return token;
    //ou
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: 21)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{},
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }
}
