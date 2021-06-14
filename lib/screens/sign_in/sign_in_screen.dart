import 'package:data/data.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class SignInScreen extends StatefulWidget {
  static get route => MaterialPageRoute(
        builder: (context) => SignInScreen(),
      );

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, state) {
          if (state.status == AuthenticationStatus.authenticationFailed) {
            String message;
            if (state.failure is WrongPasswordFailure ||
                state.failure is UserNotFoundFailure) {
              message = S.of(context).incorrectInformationPleaseTryAgain;
            } else {
              message = S
                  .of(context)
                  .aProblemOccurredWhileLoggingToYourAccountPleaseTry;
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
              } else if (state.user.isAdmin) {
                Navigator.of(context).pushAndRemoveUntil(
                  AdminHomeScreen.route,
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
        builder: (context, state) {
          if (state.status == AuthenticationStatus.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0000a0),
                            Color(0xFF00009b),
                            Color(0xFF00007b),
                            Color(0xFF00005d),
                          ],
                          stops: [0.1, 0.4, 0.7, 0.9],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 100.0,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlutterLogo(
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  S.of(context).signIn,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                _buildUniversityIdTF(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _buildPasswordTF(),
                                SizedBox(
                                  height: 50.0,
                                ),
                                RoundedRectangularButton(
                                  label: S.of(context).signIn,
                                  onPressed: _onPressed,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                RoundedRectangularButton(
                                  label: S.of(context).language,
                                  onPressed: () {
                                    context.read<LocaleCubit>().switchLocale(
                                          Localizations.localeOf(context),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUniversityIdTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).userId,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterSomeText;
              }
              universityId = value;
              return null;
            },

            keyboardType: TextInputType.number,

            inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.perm_identity_outlined,
                color: Colors.white,
              ),
              hintText: S.of(context).enterAValidUserId,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).password,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterSomeText;
              }
              password = value;
              return null;
            },

            keyboardType: TextInputType.number,

            inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            obscureText: true,

            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: S.of(context).enterYourPassword,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
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
            content:
                Text(S.of(context).youNeedToBeConnectedToTheInternetToLogin),
          ),
        );
      }
    }
  }
}
