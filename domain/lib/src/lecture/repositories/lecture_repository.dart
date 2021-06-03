import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../entities/lecture_entity.dart';

abstract class LectureRepository {
  Future<Either<Failure, List<LectureEntity>>> getLecture(
      List<String> lectures);

  /// Creates a new Lecture .
  /// returns the new Lecture id.
  Future<Either<Failure, String>> addLecture(String name);

  Future<Either<Failure, void>> deleteLecture(String lectureId);

  Future<Either<Failure, void>> updateLecture(LectureEntity lecture);
}
