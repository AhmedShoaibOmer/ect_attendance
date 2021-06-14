part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdminInitialState extends AdminState {}

class AdminLoadingState extends AdminState {}

class UserDeletedState extends AdminState {}

class UserDeleteFailedState extends AdminState {}

class CourseDeletedState extends AdminState {}

class CourseDeleteFailedState extends AdminState {}

class UseraAddedEditedState extends AdminState {}

class UserAddingEditingFailedState extends AdminState {}

class UsersaAddedState extends AdminState {}

class UsersAddingFailedState extends AdminState {}

class NoInternetConnectionState extends AdminState {}
