part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {}

class AttendanceRegistrationRequested extends StudentEvent {
  final String code;

  final String studentId;

  AttendanceRegistrationRequested({
    @required this.studentId,
    @required this.code,
  });

  @override
  List<Object> get props => [code, studentId];
}
