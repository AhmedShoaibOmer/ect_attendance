part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends StudentState {}

class LoadingState extends StudentState {}

class AttendanceRegisteredState extends StudentState {
  final String lectureName;

  AttendanceRegisteredState(this.lectureName);

  @override
  List<Object> get props => [lectureName];
}

class AttendanceRegistrationFailedState extends StudentState {}

class NoNetworkConnectionState extends StudentState {}
