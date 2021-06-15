import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class UserRepositoryImpl extends UserRepository {
  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl({
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  @override
  void dispose() {
    _firestoreService.dispose();
  }

  @override
  Future<List<UserEntity>> getStudents(List<String> studentsIds) =>
      _firestoreService.getUsers(studentsIds);

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.deleteUser(userId);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UserDeleteFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addEditUser(UserEntity userEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.addEditUser(userEntity);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UserAddEditFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUsers(List<UserEntity> users) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.addUsers(users);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UsersAddingFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<List<UserEntity>> getStudentsForCourse(CourseEntity courseEntity) =>
      _firestoreService.getUsersForCourse(courseEntity);
}
