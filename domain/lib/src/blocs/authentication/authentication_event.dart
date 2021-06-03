part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final String universityId;
  final String password;

  AuthenticationLoginRequested({
    @required this.universityId,
    @required this.password,
  });

  @override
  List<Object> get props => [universityId, password];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
