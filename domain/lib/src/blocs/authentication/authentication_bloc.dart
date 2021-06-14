import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    // Start listening to the user stream as soon as the bloc created.
    _userSubscription = _authenticationRepository.user.listen((user) {
      add(
        AuthenticationUserChanged(user),
      );
      print('User changes received a value.');
    });
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserEntity> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield* _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLoginRequested) {
      yield* _mapAuthenticationLoginRequestedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      yield* _mapAuthenticationLogOutRequestedToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async* {
    print('Mapping User changes event to state...');

    final currentUser = event.user;

    if (currentUser == null) {
      yield AuthenticationState.authenticationFailed();
    } else if (currentUser == UserEntity.empty) {
      yield AuthenticationState.unauthenticated();
    } else {
      print('user authenticated $currentUser');
      yield AuthenticationState.authenticated(currentUser);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoginRequestedToState(
      AuthenticationLoginRequested event) async* {
    yield AuthenticationState.loading();
    final response = await _authenticationRepository.loginWithUniversityId(
      universityId: event.universityId,
      password: event.password,
    );

    if (response.isLeft()) {
      yield* response.fold((l) async* {
        yield AuthenticationState.authenticationFailed(failure: l);
      }, (r) async* {});
    }
  }

  Stream<AuthenticationState>
      _mapAuthenticationLogOutRequestedToState() async* {
    yield AuthenticationState.loading();
    final response = await _authenticationRepository.logOutUser();
    if (response.isLeft()) {
      yield AuthenticationState.authenticationFailed();
    }
  }

  @override
  Future<void> close() async {
    _userSubscription.cancel();
    super.close();
  }
}
