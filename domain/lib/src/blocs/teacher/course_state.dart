part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  final CourseEntity course;

  CourseState(this.course);

  @override
  List<Object> get props => [course];
}

class CourseLoadingState extends CourseState {
  CourseLoadingState() : super(CourseEntity.empty);
}

class CourseLoadedState extends CourseState {
  CourseLoadedState(CourseEntity course) : super(course);
}

class LectureCreatedState extends CourseState {
  final String lectureId;

  LectureCreatedState({
    @required this.lectureId,
    @required CourseEntity course,
  }) : super(course);
}

class LectureCreationFailedState extends CourseState {
  LectureCreationFailedState(CourseEntity course) : super(course);
}

class LectureUpdatedState extends CourseState {
  LectureUpdatedState(CourseEntity course) : super(course);
}

class AttendanceExcelFileCreationFailedState extends CourseState {
  AttendanceExcelFileCreationFailedState(CourseEntity course) : super(course);
}

class AttendanceExcelFileCreatedState extends CourseState {
  final ExcelFileEntity excelFileEntity;

  AttendanceExcelFileCreatedState({
    @required CourseEntity course,
    @required this.excelFileEntity,
  }) : super(course);
}

class LectureUpdateFailedState extends CourseState {
  LectureUpdateFailedState(CourseEntity course) : super(course);
}

class LectureDeletedState extends CourseState {
  LectureDeletedState(CourseEntity course) : super(course);
}

class LectureDeleteFailedState extends CourseState {
  LectureDeleteFailedState(CourseEntity course) : super(course);
}

class NoConnectionState extends CourseState {
  NoConnectionState(CourseEntity course) : super(course);
}
