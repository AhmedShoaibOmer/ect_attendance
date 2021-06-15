import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteDepartmentDialog extends StatefulWidget {
  final Department department;

  const DeleteDepartmentDialog({Key key, this.department}) : super(key: key);

  @override
  _DeleteDepartmentDialogState createState() => _DeleteDepartmentDialogState();
}

class _DeleteDepartmentDialogState extends State<DeleteDepartmentDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AlertDialog(
        title: Text(
          '${S.of(context).delete} ${S.of(context).department}',
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
            if (state is DepartmentDeletedState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).deletedSuccessfully),
                ),
              );
            }
            if (state is DepartmentDeleteFailedState) {
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
                  onPressed: () => _deleteDepartment(context),
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

  void _deleteDepartment(BuildContext context) {
    context.read<AdminBloc>().add(DeleteDepartmentEvent(widget.department.id));
  }

  Widget _contentWidget() {
    return Text(
      '${S.of(context).areYouSureYouWantToDelete} ${widget.department.name}?',
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
  }
}
