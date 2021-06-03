import 'package:data/data.dart';
import 'package:domain/domain.dart';
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

  runApp(BlocProvider(
    create: (_) => AuthenticationBloc(
      authenticationRepository: authenticationRepository,
    ),
    child: ECTApp(),
  ));
}
