import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User entity
///
/// [UserEntity.empty]6 represents an unauthenticated user.
/// {@endtemplate}
class UserEntity extends Equatable {
  /// {@macro user}
  const UserEntity({
    @required this.id,
    @required this.name,
    @required this.role,
    @required this.semester,
    @required this.departmentId,
  }) : assert(id != null);

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  final int semester;

  /// the current user's role.
  final String role;

  final String departmentId;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserEntity(
    id: '',
    name: null,
    semester: 0,
    departmentId: null,
    role: null,
  );

  static const Student = 'student';
  static const Teacher = 'teacher';
  static const Admin = 'admin';

  /// If true true this user is an admin and have extra privileges.
  bool get isAdmin => this.role == UserEntity.Admin;

  /// If true true this user is a teacher.
  bool get isTeacher => this.role == UserEntity.Teacher;

  @override
  List<Object> get props => [
        id,
        name,
        role,
        departmentId,
        semester,
      ];
}
