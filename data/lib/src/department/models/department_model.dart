import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'department_model.g.dart';

@JsonSerializable()
class Department extends DepartmentEntity {
  Department({
    @required String name,
    @required this.id,
  }) : super(
          id: id,
          name: name,
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

  Department copyWith({
    String id,
    String name,
  }) =>
      Department(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}
