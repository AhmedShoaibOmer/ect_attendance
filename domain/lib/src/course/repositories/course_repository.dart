import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../core/core.dart';
import '../../lecture/lecture.dart';
import '../../user/user.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  Stream<CourseEntity> course(String courseId);

  Future<Either<Failure, void>> deleteCourse(String courseId);

  Future<Either<Failure, void>> addEditCourse(CourseEntity course);

  Future<Either<Failure, ExcelFileEntity>> createAttendanceExcelFile({
    @required String fileName,
    @required List<UserEntity> students,
    @required List<LectureEntity> lectures,
    @required String directoryPath,
    String nameColumnLabel = 'Name',
    String studentIdColumnLabel = 'Student ID',
    String lectureColumnLabel = 'Lecture',
    String attendancePercentColumnLabel = 'Attendance percent',
    String excusedAbsencePercentColumnLabel = 'Excused absence percent',
    String absencePercentColumnLabel = 'Absence percent',
    String presentTextValue = 'Present',
    String absentTextValue = 'Absent',
    String excusedAbsentTextValue = 'Absent with excuse',
  });
}
