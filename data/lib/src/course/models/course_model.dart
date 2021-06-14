import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Course extends CourseEntity {
  Course({
    @required String name,
    @required String semester,
    @required this.id,
    @required String teacherId,
    @required List<String> studentsIds,
  }) : super(
    id: id,
          name: name,
          semester: semester,
          teacherId: teacherId,
          studentsIds: studentsIds,
        );

  /// The current course's id.
  ///
  /// we do not need to write the course id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  Course copyWith({
    String id,
    String name,
    String semester,
    String teacherId,
    List<String> studentsIds,
  }) =>
      Course(
        id: id ?? this.id,
        name: name ?? this.name,
        studentsIds: studentsIds ?? this.studentsIds,
        teacherId: teacherId ?? this.teacherId,
        semester: semester ?? this.semester,
      );

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
