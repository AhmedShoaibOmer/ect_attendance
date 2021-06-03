import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String semester;
  final List<String> lecturesIds;

  CourseEntity({
    @required this.id,
    @required this.name,
    @required this.semester,
    @required this.lecturesIds,
  }) : assert(id != null && name != null);

  @override
  List<Object> get props => [
        id,
        name,
        lecturesIds,
        semester,
      ];
}
