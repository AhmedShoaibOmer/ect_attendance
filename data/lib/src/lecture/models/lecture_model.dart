import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'lecture_model.g.dart';

@JsonSerializable()
class Lecture extends LectureEntity {
  Lecture({
    @required this.id,
    @required String name,
    @required this.date,
    List<String> attendeesIds = const [],
    List<String> absentIds = const [],
    List<String> excusedAbsenteesIds = const [],
  }) : super(
    id: id,
          name: name,
          date: date,
          attendeesIds: attendeesIds,
          absentIds: absentIds,
          excusedAbsenteesIds: excusedAbsenteesIds,
        );

  /// The current Lecture's id.
  ///
  /// we do not need to write the Lecture id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  @override
  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  final DateTime date;

  static dateFromJson(dynamic date) {
    return date == null ? null : (date as Timestamp).toDate();
  }

  static dateToJson(dynamic dateTime) {
    return dateTime as DateTime;
  }

  Lecture copyWith({
    String id,
    String name,
    DateTime date,
    List<String> attendeesIds,
    List<String> absentIds,
    List<String> excusedAbsenteesIds,
  }) =>
      Lecture(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        attendeesIds: attendeesIds ?? this.attendeesIds,
        absentIds: absentIds ?? this.absentIds,
        excusedAbsenteesIds: excusedAbsenteesIds ?? this.excusedAbsenteesIds,
      );

  factory Lecture.fromJson(Map<String, dynamic> json) =>
      _$LectureFromJson(json);

  Map<String, dynamic> toJson() => _$LectureToJson(this);
}
