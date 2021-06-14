import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../generated/l10n.dart';
import '../locale_cubit.dart';
import '../screens/sign_in/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildWelcomeCard(context),
          Divider(),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final role = context.read<AuthenticationBloc>().state.user.role;

    String userRole = '';

    if (role == UserEntity.Admin) {
      userRole = S.of(context).admin;
    } else if (role == UserEntity.Teacher) {
      userRole = S.of(context).teacher;
    } else {
      userRole = S.of(context).student;
    }

    return AppBar(
      title: Text(
        '${S.of(context).app_name} - $userRole',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        Builder(
          builder: (context) {
            var locale = context.select((LocaleCubit lC) => lC.state.locale);
            if (locale == null) locale = Localizations.localeOf(context);
            return TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                primary: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
              ),
              child: Text(
                locale == Locale('ar') ? 'En' : 'عربي',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                context.read<LocaleCubit>().switchLocale(
                      locale,
                    );
              },
            );
          },
        ),
        IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.pushAndRemoveUntil(
                  context, SignInScreen.route, (route) => false);
            }),
      ],
      elevation: 0,
    );
  }

  Center buildWelcomeCard(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: Color(0xFF004aaa),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                right: 24,
                left: 24,
                bottom: 6,
              ),
              child: Text(
                S.of(context).welcome,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 24,
                left: 24,
                bottom: 24,
              ),
              child: Builder(
                builder: (BuildContext context) {
                  final name = context.select(
                    (AuthenticationBloc aB) => aB.state.user.name,
                  );
                  return Text(
                    '${name ?? ''}',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
