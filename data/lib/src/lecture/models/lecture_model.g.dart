// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lecture _$LectureFromJson(Map<String, dynamic> json) {
  return Lecture(
    id: json['id'] as String,
    name: json['name'] as String,
    attendeesIds:
        (json['attendeesIds'] as List)?.map((e) => e as String)?.toList(),
    absentIds: (json['absentIds'] as List)?.map((e) => e as String)?.toList(),
    excusedAbsenteesIds: (json['excusedAbsenteesIds'] as List)
        ?.map((e) => e as String)
        ?.toList(),
  );
}

Map<String, dynamic> _$LectureToJson(Lecture instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'attendeesIds': instance.attendeesIds,
    'absentIds': instance.absentIds,
    'excusedAbsenteesIds': instance.excusedAbsenteesIds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', Lecture.toNull(instance.id));
  return val;
}
