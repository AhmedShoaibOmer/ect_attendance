import 'package:dartz/dartz.dart';

import '../../../domain.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getStudents(List<String> studentsIds);

  Future<List<UserEntity>> getStudentsForCourse(CourseEntity courseEntity);

  /// Used to clean or the resources from the memory.
  void dispose();

  Future<Either<Failure, void>> deleteUser(String userId);

  Future<Either<Failure, void>> addEditUser(UserEntity userEntity);

  Future<Either<Failure, void>> addUsers(List<UserEntity> users);
}
