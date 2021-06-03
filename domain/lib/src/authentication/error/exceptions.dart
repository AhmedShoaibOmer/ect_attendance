import 'package:meta/meta.dart';

class UserNotFoundException implements Exception {
  final String userId;

  UserNotFoundException({@required this.userId});

  String toString() {
    return "UserNotFoundException: No User found associated with the userId: $userId.";
  }
}

class WrongPasswordException implements Exception {
  WrongPasswordException();

  String toString() {
    return "WrongPasswordException: The password you interred is incorrect.";
  }
}
