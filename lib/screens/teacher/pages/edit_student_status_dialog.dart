import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import 'lecture_page.dart';

class EditStudentStatusDialog extends StatefulWidget {
  final User student;

  final StudentStatus initialStatus;

  final Lecture lecture;

  const EditStudentStatusDialog(
      {Key key, this.student, this.initialStatus, this.lecture})
      : super(key: key);

  @override
  _EditStudentStatusDialogState createState() =>
      _EditStudentStatusDialogState();
}

class _EditStudentStatusDialogState extends State<EditStudentStatusDialog> {
  StudentStatus selectedValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AlertDialog(
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
            if (state is LectureUpdatedState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).statusUpdatedSuccessfully),
                ),
              );
            }
            if (state is LectureUpdateFailedState) {
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
          child: _contentWidget(context),
        ),
        actions: [
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => _setStatus(context),
                  child: Text(S.of(context).save),
                ),
          TextButton(
            onPressed: isLoading
                ? null
                : () {
                    Navigator.pop(context);
                  },
            child: Text(S.of(context).cancel),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            '${S.of(context).name}: ${widget.student.name}',
            style: Theme.of(context).textTheme.subtitle1.apply(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '${S.of(context).student_id}: ${widget.student.id}',
            style: Theme.of(context).textTheme.subtitle1.apply(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          Divider(),
          RadioListTile<StudentStatus>(
            title: Text(
              S.of(context).present,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            activeColor: Colors.green,
            value: StudentStatus.present,
            groupValue: selectedValue,
            onChanged: isLoading
                ? null
                : (StudentStatus value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
          ),
          RadioListTile<StudentStatus>(
            title: Text(
              S.of(context).absent_with_excuse,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            activeColor: Colors.orange,
            value: StudentStatus.absentWithExcuse,
            groupValue: selectedValue,
            onChanged: isLoading
                ? null
                : (StudentStatus value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
          ),
          RadioListTile<StudentStatus>(
            title: Text(
              S.of(context).absent,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            activeColor: Colors.red,
            value: StudentStatus.absent,
            groupValue: selectedValue,
            onChanged: isLoading
                ? null
                : (StudentStatus value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
          ),
        ],
      ),
    );
  }

  void _setStatus(BuildContext context) {
    if (selectedValue == widget.initialStatus) {
      return Navigator.pop(context);
    }

    List<String> absentIds = widget.lecture.absentIds;
    List<String> excusedAbsenteesIds = widget.lecture.excusedAbsenteesIds;
    List<String> attendeesIds = widget.lecture.attendeesIds;

    absentIds.removeWhere((element) {
      return element == widget.student.id;
    });

    excusedAbsenteesIds.removeWhere((element) {
      return element == widget.student.id;
    });

    attendeesIds.removeWhere((element) {
      return element == widget.student.id;
    });

    switch (selectedValue) {
      case StudentStatus.absent:
        absentIds.add(widget.student.id);
        break;
      case StudentStatus.absentWithExcuse:
        excusedAbsenteesIds.add(widget.student.id);
        break;
      case StudentStatus.present:
        attendeesIds.add(widget.student.id);
        break;
    }

    final lecture = widget.lecture.copyWith(
      absentIds: absentIds,
      attendeesIds: attendeesIds,
      excusedAbsenteesIds: excusedAbsenteesIds,
    );

    context.read<CourseBloc>().add(UpdateLectureEvent(lecture));
  }
}
