import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteUserDialog extends StatefulWidget {
  final User user;

  const DeleteUserDialog({Key key, this.user}) : super(key: key);

  @override
  _DeleteUserDialogState createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AlertDialog(
        title: Text(
          '${S.of(context).delete} ${widget.user.isTeacher ? S.of(context).teacher : S.of(context).student}',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        content: BlocListener<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminLoadingState) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is UserDeletedState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).deletedSuccessfully),
                ),
              );
            }
            if (state is UserDeleteFailedState) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).something_went_wrong),
                ),
              );
            }
            if (state is NoInternetConnectionState) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).no_connection_error),
                ),
              );
            }
          },
          child: _contentWidget(),
        ),
        actions: [
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => _deleteUser(context),
                  child: Text(S.of(context).delete.toUpperCase()),
                ),
          TextButton(
            onPressed: isLoading
                ? null
                : () {
                    Navigator.pop(context);
                  },
            child: Text(S.of(context).cancel.toUpperCase()),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context) {
    context.read<AdminBloc>().add(DeleteUserEvent(widget.user.id));
  }

  Widget _contentWidget() {
    return Text(
      '${S.of(context).areYouSureYouWantToDelete} ${widget.user.name}?',
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
  }
}
