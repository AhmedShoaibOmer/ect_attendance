import '../../core/core.dart';

/// Thrown during the login process if a failure occurs.
class LogInFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class UserNotFoundFailure extends Failure {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure extends Failure {}
