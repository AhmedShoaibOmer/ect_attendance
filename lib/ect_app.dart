import 'package:ect_attendance/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'screens/splash/splash_screen.dart';

class ECTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return MaterialApp(
          locale: state.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xff00008b),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'OpenSans'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: SplashScreen(),
        );
      },
    );
  }
}
