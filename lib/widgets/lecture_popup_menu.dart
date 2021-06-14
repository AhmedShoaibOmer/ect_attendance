import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../generated/l10n.dart';
import '../screens/teacher/pages/add_edit_lecture_dialog.dart';
import '../screens/teacher/pages/delete_lecture_dialog.dart';
import '../utilities/global.dart';

class LecturePopupMenu extends StatelessWidget {
  final bool popAfterDelete;

  final Function(Lecture) onLectureUpdated;

  const LecturePopupMenu({
    Key key,
    @required this.lecture,
    this.popAfterDelete,
    this.onLectureUpdated,
  }) : super(key: key);

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(10),
        ),
      ),
      onSelected: (int result) async {
        final bloc = BlocProvider.of<CourseBloc>(context);
        if (result == 0) {
          final updatedLecture = await showPrimaryDialog<Lecture>(
            context: context,
            dialog: BlocProvider.value(
              value: bloc,
              child: AddEditLecture(
                lecture: lecture,
              ),
            ),
          );
          onLectureUpdated(updatedLecture);
        } else {
          await showPrimaryDialog(
            context: context,
            dialog: BlocProvider.value(
              value: bloc,
              child: DeleteLectureDialog(
                lecture: lecture,
              ),
            ),
          );
          if (popAfterDelete) Navigator.pop(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  S.of(context).edit,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  S.of(context).delete,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
