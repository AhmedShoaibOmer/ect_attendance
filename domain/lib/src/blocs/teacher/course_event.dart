part of 'course_bloc.dart';

abstract class CourseEvent {}

class CreateNewLectureEvent extends CourseEvent {
  final String name;
  final DateTime date;

  CreateNewLectureEvent({
    @required this.name,
    @required this.date,
  });
}

class CourseChangedEvent extends CourseEvent {
  final CourseEntity course;

  CourseChangedEvent(this.course);
}

class UpdateLectureEvent extends CourseEvent {
  final LectureEntity lecture;

  UpdateLectureEvent(this.lecture);
}

class DeleteLectureEvent extends CourseEvent {
  final String lectureId;

  DeleteLectureEvent(this.lectureId);
}

class CreateAttendanceExcelFileEvent extends CourseEvent {
  final List<LectureEntity> lectures;
  final String directoryPath;
  final String nameColumnLabel;
  final String studentIdColumnLabel;
  final String lectureColumnLabel;
  final String attendancePercentColumnLabel;
  final String excusedAbsencePercentColumnLabel;
  final String absencePercentColumnLabel;
  final String presentTextValue;
  final String absentTextValue;
  final String excusedAbsentTextValue;

  CreateAttendanceExcelFileEvent({
    @required this.lectures,
    @required this.directoryPath,
    this.nameColumnLabel,
    this.studentIdColumnLabel,
    this.lectureColumnLabel,
    this.attendancePercentColumnLabel,
    this.excusedAbsencePercentColumnLabel,
    this.absencePercentColumnLabel,
    this.presentTextValue,
    this.absentTextValue,
    this.excusedAbsentTextValue,
  });
}
