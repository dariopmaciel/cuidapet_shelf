
class User {

  final int? id;
  final String? email;
  final String? password;
  final String? registerType;
  final String? imageAvatar;
  final String? iosToken;
  final String? androidToken;
  final String? refreshToken;
  final String? socialKey;
  final int? supplierId;

  User({
    this.id,
    this.email,
    this.password,
    this.registerType,
    this.iosToken,
    this.androidToken,
    this.refreshToken,
    this.socialKey,
    this.imageAvatar,
    this.supplierId,
  });

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? registerType,
    String? iosToken,
    String? androidToken,
    String? refreshToken,
    String? socialKey,
    int? supplierId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      registerType: registerType ?? this.registerType,
      iosToken: iosToken ?? this.iosToken,
      androidToken: androidToken ?? this.androidToken,
      refreshToken: refreshToken ?? this.refreshToken,
      socialKey: socialKey ?? this.socialKey,
      supplierId: supplierId ?? this.supplierId,
    );
  }
}
