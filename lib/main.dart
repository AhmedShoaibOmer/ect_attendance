import 'package:data/data.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/locale_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ect_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing firebase app to it services.
  await Firebase.initializeApp();

  final firestoreService = FirestoreService.instance;

  final authenticationRepository =
      AuthenticationRepositoryImpl(firestoreService: firestoreService);

  final networkInfo =
      NetworkInfoImpl(dataConnectionChecker: DataConnectionChecker());

  final CourseRepository courseRepository = CourseRepositoryImpl(
    firestoreService: firestoreService,
    networkInfo: networkInfo,
  );

  final LectureRepository lectureRepository = LectureRepositoryImpl(
    firestoreService: firestoreService,
    networkInfo: networkInfo,
  );

  final UserRepository userRepository = UserRepositoryImpl(
    firestoreService: firestoreService,
    networkInfo: networkInfo,
  );

  final DepartmentRepository departmentRepository = DepartmentRepositoryImpl(
    firestoreService: firestoreService,
    networkInfo: networkInfo,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => lectureRepository,
        ),
        RepositoryProvider(
          create: (context) => courseRepository,
        ),
        RepositoryProvider(
          create: (context) => userRepository,
        ),
        RepositoryProvider(
          create: (context) => departmentRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => LocaleCubit(),
          ),
        ],
        child: ECTApp(),
      ),
    ),
  );
}
