part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {}

class AttendanceRegistrationRequested extends StudentEvent {
  final String code;

  final UserEntity student;

  AttendanceRegistrationRequested({
    @required this.student,
    @required this.code,
  });

  @override
  List<Object> get props => [code, student];
}
