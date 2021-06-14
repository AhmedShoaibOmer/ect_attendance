import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:data/src/services/preferences/shared_preferences_service.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final FirestoreService _firestoreService;

  AuthenticationRepositoryImpl({
    @required FirestoreService firestoreService,
  })  : assert(firestoreService != null),
        this._firestoreService = firestoreService;

  //start listening for the authentication changes.
  @override
  Stream<UserEntity> get user async* {
    // Check from cache if there is  user authenticated.
    final preferences = await SharedPreferencesService.instance;
    final currentUserId = preferences.currentUserId;

    // null if there's no user authenticated.
    if (currentUserId == null || currentUserId.isEmpty) {
      yield UserEntity.empty;
    } else {
      _firestoreService.getUser();
    }
    // start listening to the stream of user changes.
    yield* _firestoreService.userChanges;
  }

  @override
  Future<Either<Failure, void>> loginWithUniversityId({
    @required String universityId,
    @required String password,
  }) async {
    try {
      if (universityId == password) {
        await _firestoreService.getUser(userId: universityId);
        await FirebaseAuth.instance.signInAnonymously();
        return Right(() {});
      } else {
        throw WrongPasswordException();
      }
    } catch (e) {
      print('login failed: $e');
      if (e is WrongPasswordException) {
        return Left(WrongPasswordFailure());
      } else if (e is UserNotFoundException) {
        return Left(UserNotFoundFailure());
      } else {
        return Left(LogInFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> logOutUser() async {
    try {
      final preferences = await SharedPreferencesService.instance;
      await preferences.setCurrentUserId('');
      _firestoreService.userLoggedOut();
      await FirebaseAuth.instance.signOut();
      return Right(() {});
    } catch (e) {
      print('LogOut failed: $e');
      return Left(LogOutFailure());
    }
  }
}
