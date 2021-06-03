import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print(state.status);
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            if (state.user.isTeacher) {
              Navigator.of(context).pushAndRemoveUntil(
                TeacherHomeScreen.route,
                (route) => false,
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                StudentHomeScreen.route,
                (route) => false,
              );
            }
            break;
          case AuthenticationStatus.authenticationFailed:
          case AuthenticationStatus.unauthenticated:
            Navigator.of(context).pushAndRemoveUntil(
              AuthScreen.route,
              (route) => false,
            );
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
