import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final int semester;
  final String departmentId;
  final String teacherId;

  const CourseEntity({
    @required this.id,
    @required this.name,
    @required this.semester,
    @required this.departmentId,
    @required this.teacherId,
  }) : assert(id != null && name != null);

  static const empty = CourseEntity(
    id: '',
    name: '',
    teacherId: '',
    departmentId: '',
    semester: 0,
  );

  @override
  List<Object> get props => [
        id,
        name,
        semester,
        departmentId,
        teacherId,
      ];
}
