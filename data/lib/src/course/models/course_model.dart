import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Course extends CourseEntity {
  Course({
    String name,
    String semester,
    List<String> lecturesIds,
    @required this.id,
  }) : super(
          id: id,
          name: name,
          semester: semester,
          lecturesIds: lecturesIds,
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
    List<String> lecturesIds,
  }) =>
      Course(
        id: id ?? this.id,
        name: name ?? this.name,
        semester: semester ?? this.semester,
        lecturesIds: lecturesIds ?? this.lecturesIds,
      );

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
