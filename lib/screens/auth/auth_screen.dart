import 'package:data/data.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';

class AuthScreen extends StatefulWidget {
  static var route = MaterialPageRoute(
    builder: (context) => AuthScreen(),
  );

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Creates a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String universityId;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, state) {
          if (state.status == AuthenticationStatus.authenticationFailed) {
            String message;
            if (state.failure is WrongPasswordFailure ||
                state.failure is UserNotFoundFailure) {
              message = 'Incorrect Information. Please Try again.';
            } else {
              message =
                  'A problem occurred while logging to your account. Please Try again.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          } else {
            if (state.status == AuthenticationStatus.authenticated) {
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
            }
          }
        },
        child: SafeArea(
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 150,
                            child: Text(
                              'ECT Attendance',
                              style: TextStyle(
                                fontSize: 34,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),

                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (value.length != 10) {
                              return 'IDs should be 10 digits long';
                            }
                            universityId = value;
                            return null;
                          },

                          keyboardType: TextInputType.number,

                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],

                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'University ID',
                              hintText: 'Enter a valid University ID'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),

                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            password = value;
                            return null;
                          },

                          keyboardType: TextInputType.number,

                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],

                          obscureText: true,

                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter secure password'),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: _onPressed,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        )),
      ),
    );
  }

  Future<void> _onPressed() async {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState.validate()) {
      final NetworkInfo networkInfo =
          NetworkInfoImpl(dataConnectionChecker: DataConnectionChecker());
      if (await networkInfo.isConnected) {
        context.read<AuthenticationBloc>().add(
              AuthenticationLoginRequested(
                universityId: universityId,
                password: password,
              ),
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You need to be connected to the internet to login.'),
          ),
        );
      }
    }
  }
}
