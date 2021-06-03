import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class UserRepositoryImpl extends UserRepository {
  final FirestoreService _firestoreService;

  UserRepositoryImpl({
    @required FirestoreService firestoreService,
  })  : assert(firestoreService != null),
        this._firestoreService = firestoreService;

  @override
  void dispose() {
    _firestoreService.dispose();
  }

  @override
  Future<Either<Failure, void>> submitAttendance(String lectureId) {
    // TODO: implement submitAttendance
    throw UnimplementedError();
  }
}
