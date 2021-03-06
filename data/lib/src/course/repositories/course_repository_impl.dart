import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class CourseRepositoryImpl extends CourseRepository {
  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  CourseRepositoryImpl({
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> deleteCourse(String courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.deleteCourse(courseId);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(CourseDeleteFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addEditCourse(CourseEntity course) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.addEditCourse(course: course);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(CourseAddEditFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Stream<CourseEntity> course(
    String courseId,
  ) =>
      _firestoreService.course(courseId);

  @override
  Future<Either<Failure, ExcelFileEntity>> createAttendanceExcelFile({
    String fileName,
    List<UserEntity> students,
    List<LectureEntity> lectures,
    String directoryPath,
    String nameColumnLabel = 'Name',
    String studentIdColumnLabel = 'Student ID',
    String lectureColumnLabel = 'Lecture',
    String attendancePercentColumnLabel = 'Attendance percent',
    String excusedAbsencePercentColumnLabel = 'Excused absence percent',
    String absencePercentColumnLabel = 'Absence percent',
    String presentTextValue = 'Present',
    String absentTextValue = 'Absent',
    String excusedAbsentTextValue = 'Absent with excuse',
  }) async {
    try {
      final response = await ExcelService.createAttendanceExcelFile(
        fileName: fileName,
        students: students,
        lectures: lectures,
        directoryPath: directoryPath,
        nameColumnLabel: nameColumnLabel,
        studentIdColumnLabel: studentIdColumnLabel,
        lectureColumnLabel: lectureColumnLabel,
        attendancePercentColumnLabel: attendancePercentColumnLabel,
        excusedAbsencePercentColumnLabel: excusedAbsencePercentColumnLabel,
        absencePercentColumnLabel: absencePercentColumnLabel,
        presentTextValue: presentTextValue,
        absentTextValue: absentTextValue,
        excusedAbsentTextValue: excusedAbsentTextValue,
      );
      return Right(response);
    } catch (e) {
      print(e);
      return Left(AttendanceExcelFileCreationFailure());
    }
  }
}
