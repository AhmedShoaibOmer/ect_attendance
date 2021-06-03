import 'package:dartz/dartz.dart';

import '../../../domain.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> submitAttendance(String lectureId);

  /// Used to clean or the resources from the memory.
  void dispose();
}
