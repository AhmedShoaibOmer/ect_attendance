import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends UserEntity {
  /// {@macro user}
  const User({
    @required this.id,
    @required String name,
    String role,
  }) : super(
          name: name,
          role: role,
          id: id,
        );

  User copyWith({
    String id,
    String name,
    String role,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
      );

  /// The current user's university  id.
  ///
  /// we do not need to write the user university id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the file only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
