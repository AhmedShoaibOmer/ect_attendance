// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course(
    name: json['name'] as String,
    semester: json['semester'] as int,
    id: json['id'] as String,
    teacherId: json['teacherId'] as String,
    departmentId: json['departmentId'] as String,
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'semester': instance.semester,
    'departmentId': instance.departmentId,
    'teacherId': instance.teacherId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', Course.toNull(instance.id));
  return val;
}
