// ignore_for_file: public_member_api_docs, sort_constructors_first
// class UserExistsException implements Exception {
//   //
// }

class UserNotFoundException implements Exception {
  String message;
  UserNotFoundException({
    required this.message,
  });
}
