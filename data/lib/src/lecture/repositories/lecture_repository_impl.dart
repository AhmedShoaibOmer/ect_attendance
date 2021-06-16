import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class LectureRepositoryImpl extends LectureRepository {
  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  LectureRepositoryImpl({
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, String>> addLecture({
    @required String courseId,
    @required String name,
    @required List<String> studentsIds,
    @required DateTime dateTime,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _firestoreService.addNewLectureToCourse(
          courseId: courseId,
          studentsIds: studentsIds,
          dateTime: dateTime,
          name: name,
        );
        return Right(response);
      } catch (e) {
        print(e);
        return Left(LectureCreateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteLecture({
    String lectureId,
    String courseId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.deleteLectureFromCourse(
          courseId,
          lectureId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(LectureDeleteFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateLecture({
    LectureEntity lecture,
    String courseId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.updateLecture(
          lecture: lecture,
          courseId: courseId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(LectureUpdateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, LectureEntity>> registerAttendance({
    UserEntity student,
    String code,
  }) async {
    try {
      print('Qr data: $code');
      final data = code.split("/");
      if (data.isEmpty) throw Exception('No ids detected.');
      String courseId = data[0];
      String lectureId = data[1];
      final lecture = await _firestoreService.submitAttendance(
        student: student,
        courseId: courseId,
        lectureId: lectureId,
      );

      return Right(lecture);
    } catch (e) {
      print(e);
      if (e is StudentNotAuthorizedException) {
        return Left(StudentNotAuthorizedFailure());
      }
      return Left(AttendanceRegistrationFailure());
    }
  }
}
