import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Course extends CourseEntity {
  Course({
    @required String name,
    @required int semester,
    @required this.id,
    @required String teacherId,
    @required String departmentId,
  }) : super(
          id: id,
          name: name,
          semester: semester,
          teacherId: teacherId,
          departmentId: departmentId,
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
    int semester,
    String teacherId,
    String departmentId,
  }) =>
      Course(
        id: id ?? this.id,
        name: name ?? this.name,
        teacherId: teacherId ?? this.teacherId,
        departmentId: departmentId ?? this.departmentId,
        semester: semester ?? this.semester,
      );

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
