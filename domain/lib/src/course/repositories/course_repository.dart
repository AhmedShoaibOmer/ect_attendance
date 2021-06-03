import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getCourses(List<String> courses);

  /// Creates a new course .
  /// returns the new course id.
  Future<Either<Failure, String>> addCourse(String name);

  Future<Either<Failure, void>> deleteCourse(String courseId);

  Future<Either<Failure, void>> updateCourse(CourseEntity course);
}
