/*
 *
 *  Created Date: 1/24/21 12:41 AM
 *  Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  loading,
  authenticated,
  unauthenticated,
  authenticationFailed,
  unknown
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserEntity.empty,
    this.failure,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(
    UserEntity currentUser,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          user: currentUser,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticationFailed({Failure failure})
      : this._(
          status: AuthenticationStatus.authenticationFailed,
          failure: failure,
        );

  const AuthenticationState.loading()
      : this._(status: AuthenticationStatus.loading);

  final AuthenticationStatus status;
  final UserEntity user;
  final Failure failure;

  @override
  List<Object> get props => [status, user, failure];
}
