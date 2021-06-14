import 'dart:math';

import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/teacher/pages/qr_generate_dialog.dart';
import '../utilities/global.dart';
import 'lecture_popup_menu.dart';

class LectureListItem extends StatelessWidget {
  final Color itemColor = Colors.primaries[Random().nextInt(
    Colors.primaries.length,
  )];

  final Lecture lecture;
  final String courseId;
  final Function onPressed;

  final bool isSearchPage;

  LectureListItem(
      {Key key,
      @required this.lecture,
      @required this.courseId,
      @required this.onPressed,
      this.isSearchPage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 500,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 8,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(10),
                    bottomEnd: Radius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      lecture.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(lecture.date),
                      style: Theme.of(context).textTheme.caption.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.qr_code,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  await showPrimaryDialog(
                    context: context,
                    dialog: QRGenerateDialog(
                      courseId: courseId,
                      lectureId: lecture.id,
                    ),
                  );
                },
              ),
              isSearchPage ? Container() : LecturePopupMenu(lecture: lecture),
            ],
          ),
        ),
      ),
    );
  }
}
