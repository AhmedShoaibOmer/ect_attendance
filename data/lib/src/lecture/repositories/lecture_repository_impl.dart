import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';

import '../../services/services.dart';

class LectureRepositoryImpl extends LectureRepository {
  final FirestoreService _firestoreService;

  LectureRepositoryImpl({FirestoreService firestoreService})
      : assert(firestoreService != null),
        this._firestoreService = firestoreService;

  @override
  Future<Either<Failure, String>> addLecture(String name) {
    // TODO: implement addLecture
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteLecture(String lectureId) {
    // TODO: implement deleteLecture
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<LectureEntity>>> getLecture(
      List<String> lectures) {
    // TODO: implement getLecture
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateLecture(LectureEntity lecture) {
    // TODO: implement updateLecture
    throw UnimplementedError();
  }
}
