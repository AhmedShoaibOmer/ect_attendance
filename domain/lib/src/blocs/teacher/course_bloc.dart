import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final LectureRepository _lectureRepository;
  final CourseRepository _courseRepository;
  final UserRepository _userRepository;
  CourseEntity course = CourseEntity.empty;
  List<UserEntity> students = [];
  StreamSubscription<CourseEntity> _courseSubscription;

  CourseBloc({
    @required LectureRepository lectureRepository,
    @required CourseRepository courseRepository,
    @required UserRepository userRepository,
    @required String courseId,
  })  : assert(lectureRepository != null),
        assert(courseId != null),
        this._lectureRepository = lectureRepository,
        this._courseRepository = courseRepository,
        this._userRepository = userRepository,
        super(CourseLoadingState()) {
    // Start listening to the course stream as soon as the bloc created.
    _courseSubscription = _courseRepository.course(courseId).listen((value) {
      add(
        CourseChangedEvent(value),
      );
      print('Course changes received a value.');
    });
  }

  @override
  Stream<CourseState> mapEventToState(CourseEvent event) async* {
    if (event is CourseChangedEvent) {
      yield* _mapCourseChangedToState(event);
    } else if (event is CreateNewLectureEvent) {
      yield* _mapCreateNewLectureToState(event);
    } else if (event is UpdateLectureEvent) {
      yield* _mapUpdateLectureToState(event);
    } else if (event is DeleteLectureEvent) {
      yield* _mapDeleteLectureToState(event);
    } else if (event is CreateAttendanceExcelFileEvent) {
      yield* _mapCreateAttendanceExcelFileToState(event);
    }
  }

  Stream<CourseState> _mapCreateNewLectureToState(
      CreateNewLectureEvent event) async* {
    yield CourseLoadingState();
    final response = await _lectureRepository.addLecture(
      dateTime: event.date,
      name: event.name,
      studentsIds: students.map((e) => e.id).toList(),
      courseId: course.id,
    );

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoConnectionState(course);
      } else {
        yield LectureCreationFailedState(course);
      }
    }, (r) async* {
      yield LectureCreatedState(course: course, lectureId: r);
    });
  }

  Stream<CourseState> _mapCourseChangedToState(
      CourseChangedEvent event) async* {
    yield CourseLoadingState();
    course = event.course;
    students = await _userRepository.getStudentsForCourse(course);
    yield CourseLoadedState(course);
  }

  Stream<CourseState> _mapUpdateLectureToState(
      UpdateLectureEvent event) async* {
    yield CourseLoadingState();
    final response = await _lectureRepository.updateLecture(
      lecture: event.lecture,
      courseId: course.id,
    );

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoConnectionState(course);
      } else {
        yield LectureUpdateFailedState(course);
      }
    }, (r) async* {
      yield LectureUpdatedState(course);
    });
  }

  Stream<CourseState> _mapDeleteLectureToState(
      DeleteLectureEvent event) async* {
    yield CourseLoadingState();
    final response = await _lectureRepository.deleteLecture(
      lectureId: event.lectureId,
      courseId: course.id,
    );

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoConnectionState(course);
      } else {
        yield LectureDeleteFailedState(course);
      }
    }, (r) async* {
      yield LectureDeletedState(course);
    });
  }

  Stream<CourseState> _mapCreateAttendanceExcelFileToState(
      CreateAttendanceExcelFileEvent event) async* {
    yield CourseLoadingState();
    final response = await _courseRepository.createAttendanceExcelFile(
      fileName: course.name,
      students: students,
      lectures: event.lectures,
      directoryPath: event.directoryPath,
      nameColumnLabel: event.nameColumnLabel,
      excusedAbsentTextValue: event.excusedAbsentTextValue,
      absentTextValue: event.absentTextValue,
      presentTextValue: event.presentTextValue,
      absencePercentColumnLabel: event.absencePercentColumnLabel,
      excusedAbsencePercentColumnLabel: event.excusedAbsencePercentColumnLabel,
      attendancePercentColumnLabel: event.attendancePercentColumnLabel,
      lectureColumnLabel: event.lectureColumnLabel,
      studentIdColumnLabel: event.studentIdColumnLabel,
    );

    yield* response.fold((l) async* {
      yield AttendanceExcelFileCreationFailedState(course);
    }, (r) async* {
      yield AttendanceExcelFileCreatedState(
        course: course,
        excelFileEntity: r,
      );
    });
  }

  @override
  Future<void> close() async {
    _courseSubscription.cancel();
    super.close();
  }
}
