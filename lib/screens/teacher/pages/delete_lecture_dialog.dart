import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';

class DeleteLectureDialog extends StatefulWidget {
  final Lecture lecture;

  const DeleteLectureDialog({Key key, this.lecture}) : super(key: key);

  @override
  _DeleteLectureDialogState createState() => _DeleteLectureDialogState();
}

class _DeleteLectureDialogState extends State<DeleteLectureDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AlertDialog(
        title: Text(
          S.of(context).delete_lecture,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        content: BlocListener<CourseBloc, CourseState>(
          listener: (context, state) {
            if (state is CourseLoadingState) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is LectureDeletedState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).lectureDeletedSuccessfully),
                ),
              );
            }
            if (state is LectureDeleteFailedState) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).something_went_wrong),
                ),
              );
            }
            if (state is NoConnectionState) {
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
                  onPressed: () => _deleteLecture(context),
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

  void _deleteLecture(BuildContext context) {
    context.read<CourseBloc>().add(DeleteLectureEvent(widget.lecture.id));
  }

  Widget _contentWidget() {
    return Text(
      '${S.of(context).areYouSureYouWantToDelete} ${widget.lecture.name}?',
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
  }
}
