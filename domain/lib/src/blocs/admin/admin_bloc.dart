import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final UserRepository _userRepository;
  final CourseRepository _courseRepository;

  AdminBloc(
    UserRepository userRepository,
    CourseRepository courseRepository,
  )   : assert(userRepository != null),
        assert(courseRepository != null),
        this._userRepository = userRepository,
        this._courseRepository = courseRepository,
        super(AdminInitialState());

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    if (event is DeleteCourseEvent) {
      yield* _mapDeleteCourseEventToState(event);
    } else if (event is DeleteUserEvent) {
      yield* _mapDeleteUserEventToState(event);
    } else if (event is AddEditUserEvent) {
      yield* _mapAddEditUserEventToState(event);
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
}
