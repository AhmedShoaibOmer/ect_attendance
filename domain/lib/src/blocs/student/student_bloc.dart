import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'student_event.dart';

part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final LectureRepository _lectureRepository;

  StudentBloc(LectureRepository lectureRepository)
      : assert(lectureRepository != null),
        this._lectureRepository = lectureRepository,
        super(InitialState());

  @override
  Stream<StudentState> mapEventToState(StudentEvent event) async* {
    if (event is AttendanceRegistrationRequested) {
      yield* _mapAttendanceRegistrationRequestedToState(event);
    }
  }

  Stream<StudentState> _mapAttendanceRegistrationRequestedToState(
      AttendanceRegistrationRequested event) async* {
    yield LoadingState();
    if (event.code == null || event.code.isEmpty) {
      yield AttendanceRegistrationFailedState();
    } else {
      final response = await _lectureRepository.registerAttendance(
        studentId: event.studentId,
        code: event.code,
      );
      yield* response.fold((l) async* {
        if (l is NoConnectionFailure) {
          yield NoNetworkConnectionState();
        } else {
          yield AttendanceRegistrationFailedState();
        }
      }, (r) async* {
        yield AttendanceRegisteredState(r.name);
      });
    }
  }
}
