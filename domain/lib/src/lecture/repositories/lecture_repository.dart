import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';
import '../../core/core.dart';
import '../entities/lecture_entity.dart';

abstract class LectureRepository {
  /// Creates a new Lecture .
  /// returns the new Lecture id.
  Future<Either<Failure, String>> addLecture({
    @required String courseId,
    @required String name,
    @required List<String> studentsIds,
    @required DateTime dateTime,
  });

  Future<Either<Failure, void>> deleteLecture({
    @required String lectureId,
    @required String courseId,
  });

  Future<Either<Failure, void>> updateLecture({
    @required LectureEntity lecture,
    @required String courseId,
  });

  Future<Either<Failure, LectureEntity>> registerAttendance({
    @required UserEntity student,
    @required String code,
  });
}
