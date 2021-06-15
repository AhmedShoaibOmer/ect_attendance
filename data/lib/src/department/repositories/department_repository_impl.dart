import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class DepartmentRepositoryImpl extends DepartmentRepository {
  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  DepartmentRepositoryImpl({
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> deleteDepartment(String departmentId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.deleteDepartment(departmentId);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(DepartmentDeleteFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addEditDepartment(
      DepartmentEntity departmentEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.addEditDepartment(department: departmentEntity);
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(DepartmentAddEditFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
