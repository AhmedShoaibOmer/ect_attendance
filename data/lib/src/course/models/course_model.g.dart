// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course(
    name: json['name'] as String,
    semester: json['semester'] as String,
    id: json['id'] as String,
    teacherId: json['teacherId'] as String,
    studentsIds:
        (json['studentsIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'semester': instance.semester,
    'teacherId': instance.teacherId,
    'studentsIds': instance.studentsIds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', Course.toNull(instance.id));
  return val;
}
