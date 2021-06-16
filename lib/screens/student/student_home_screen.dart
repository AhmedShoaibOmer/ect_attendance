import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';
import '../../utilities/global.dart';
import '../../widgets/widgets.dart';
import 'pages/qr_scan_page.dart';

class StudentHomeScreen extends StatefulWidget {
  static get route => MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (_) => StudentBloc(
              RepositoryProvider.of(context),
            ),
            child: StudentHomeScreen(),
          );
        },
      );

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      child:
          BlocConsumer<StudentBloc, StudentState>(listener: (context, state) {
        if (state is AttendanceRegistrationFailedState) {
          _showFailureDialog(context);
        } else if (state is AttendanceRegisteredState) {
          _showSuccessDialog(context, state.lectureName);
        } else if (state is NoNetworkConnectionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).no_connection_error),
            ),
          );
        } else if (state is StudentNotAuthorizedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(S.of(context).youAreNotAllowedToSubmitAttendanceToAnyOf),
            ),
          );
        }
      }, builder: (context, state) {
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return QRScanPage(
            onCodeScanned: _submitAttendance,
          );
        }
      }),
    );
  }

  _showSuccessDialog(BuildContext context, String lectureName) {
    AlertDialog alert = AlertDialog(
      title: Text(
        S.of(context).operation_succeeded,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: new Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "${S.of(context).lecture_registered} : $lectureName.",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            onPrimary: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(10),
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).done.toUpperCase()),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showFailureDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        S.of(context).operation_failed,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: new Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              S.of(context).lecture_registration_failed,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            onPrimary: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(10),
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).try_again.toUpperCase()),
        ),
      ],
    );
    showPrimaryDialog(
      context: context,
      dialog: alert,
    );
  }

  void _submitAttendance(String result) async {
    if (result == null || result.isEmpty) return;

    UserEntity student = context.read<AuthenticationBloc>().state.user;

    context.read<StudentBloc>().add(AttendanceRegistrationRequested(
          student: student,
          code: result,
        ));
  }
}
