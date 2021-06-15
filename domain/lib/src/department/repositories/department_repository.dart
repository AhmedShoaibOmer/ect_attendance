import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';

import '../../core/core.dart';
import '../entities/department_entity.dart';

abstract class DepartmentRepository {
  Future<Either<Failure, void>> deleteDepartment(String departmentId);

  Future<Either<Failure, void>> addEditDepartment(
      DepartmentEntity departmentEntity);
}
