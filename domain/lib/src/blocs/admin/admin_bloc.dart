import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final UserRepository _userRepository;
  final CourseRepository _courseRepository;
  final DepartmentRepository _departmentRepository;

  AdminBloc(
    UserRepository userRepository,
    CourseRepository courseRepository,
    DepartmentRepository departmentRepository,
  )   : assert(userRepository != null),
        assert(courseRepository != null),
        assert(departmentRepository != null),
        this._userRepository = userRepository,
        this._courseRepository = courseRepository,
        this._departmentRepository = departmentRepository,
        super(AdminInitialState());

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    if (event is DeleteCourseEvent) {
      yield* _mapDeleteCourseEventToState(event);
    } else if (event is DeleteUserEvent) {
      yield* _mapDeleteUserEventToState(event);
    } else if (event is AddEditUserEvent) {
      yield* _mapAddEditUserEventToState(event);
    } else if (event is DeleteDepartmentEvent) {
      yield* _mapDeleteDepartmentEventToState(event);
    } else if (event is AddEditDepartmentEvent) {
      yield* _mapAddEditDepartmentEventToState(event);
    } else if (event is AddEditCourseEvent) {
      yield* _mapAddEditCourseEventToState(event);
    } else if (event is AddUsersEvent) {
      yield* _mapAddUsersEventToState(event);
    }
  }

  Stream<AdminState> _mapDeleteUserEventToState(DeleteUserEvent event) async* {
    yield AdminLoadingState();
    final response = await _userRepository.deleteUser(event.userId);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield UserDeleteFailedState();
      }
    }, (r) async* {
      yield UserDeletedState();
    });
  }

  Stream<AdminState> _mapDeleteDepartmentEventToState(
      DeleteDepartmentEvent event) async* {
    yield AdminLoadingState();
    final response =
        await _departmentRepository.deleteDepartment(event.departmentId);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield DepartmentDeleteFailedState();
      }
    }, (r) async* {
      yield DepartmentDeletedState();
    });
  }

  Stream<AdminState> _mapDeleteCourseEventToState(
      DeleteCourseEvent event) async* {
    yield AdminLoadingState();
    final response = await _courseRepository.deleteCourse(event.courseId);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield CourseDeleteFailedState();
      }
    }, (r) async* {
      yield CourseDeletedState();
    });
  }

  Stream<AdminState> _mapAddEditUserEventToState(
      AddEditUserEvent event) async* {
    yield AdminLoadingState();
    final response = await _userRepository.addEditUser(event.user);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield UserAddingEditingFailedState();
      }
    }, (r) async* {
      yield UseraAddedEditedState();
    });
  }

  Stream<AdminState> _mapAddEditDepartmentEventToState(
      AddEditDepartmentEvent event) async* {
    yield AdminLoadingState();
    final response =
        await _departmentRepository.addEditDepartment(event.departmentEntity);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield DepartmentAddingEditingFailedState();
      }
    }, (r) async* {
      yield DepartmentAddedEditedState();
    });
  }

  Stream<AdminState> _mapAddUsersEventToState(AddUsersEvent event) async* {
    yield AdminLoadingState();
    final response = await _userRepository.addUsers(event.users);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield UsersAddingFailedState();
      }
    }, (r) async* {
      yield UsersaAddedState();
    });
  }

  Stream<AdminState> _mapAddEditCourseEventToState(
      AddEditCourseEvent event) async* {
    yield AdminLoadingState();
    final response = await _courseRepository.addEditCourse(event.course);

    yield* response.fold((l) async* {
      if (l is NoConnectionFailure) {
        yield NoInternetConnectionState();
      } else {
        yield CourseAddingEditingFailedState();
      }
    }, (r) async* {
      yield CourseAddedEditedState();
    });
  }
}
