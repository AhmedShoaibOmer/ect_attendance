import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String semester;
  final String teacherId;
  final List<String> studentsIds;

  const CourseEntity({
    @required this.id,
    @required this.name,
    @required this.semester,
    @required this.teacherId,
    @required this.studentsIds,
  }) : assert(id != null && name != null);

  static const empty = CourseEntity(
    id: '',
    name: '',
    teacherId: '',
    semester: '5',
    studentsIds: [],
  );

  @override
  List<Object> get props => [
        id,
        name,
        semester,
        teacherId,
        studentsIds,
      ];
}
