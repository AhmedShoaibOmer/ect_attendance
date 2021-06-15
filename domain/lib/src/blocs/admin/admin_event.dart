part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
}

class DeleteUserEvent extends AdminEvent {
  final String userId;

  DeleteUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteCourseEvent extends AdminEvent {
  final String courseId;

  DeleteCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class DeleteDepartmentEvent extends AdminEvent {
  final String departmentId;

  DeleteDepartmentEvent(this.departmentId);

  @override
  List<Object> get props => [departmentId];
}

class AddEditUserEvent extends AdminEvent {
  final UserEntity user;

  AddEditUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class AddUsersEvent extends AdminEvent {
  final List<UserEntity> users;

  AddUsersEvent(this.users);

  @override
  List<Object> get props => [users];
}

class AddEditCourseEvent extends AdminEvent {
  final CourseEntity course;

  AddEditCourseEvent(this.course);

  @override
  List<Object> get props => [course];
}

class AddEditDepartmentEvent extends AdminEvent {
  final DepartmentEntity departmentEntity;

  AddEditDepartmentEvent(this.departmentEntity);

  @override
  List<Object> get props => [departmentEntity];
}
