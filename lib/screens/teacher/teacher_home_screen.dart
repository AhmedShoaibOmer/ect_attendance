import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/screens/admin/pages/add_edit_course.dart';
import 'package:ect_attendance/screens/admin/pages/delete_course_dialog.dart';
import 'package:ect_attendance/utilities/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../generated/l10n.dart';
import '../../widgets/widgets.dart';
import 'pages/course_page.dart';

class TeacherHomeScreen extends StatelessWidget {
  static get route => MaterialPageRoute(
        builder: (context) => TeacherHomeScreen(),
      );

  @override
  Widget build(BuildContext context) {
    String teacherId = context.read<AuthenticationBloc>().state.user.id;

    return HomeScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Text(
              S.of(context).your_courses,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: PaginateFirestore(
              physics: BouncingScrollPhysics(),
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (index, context, documentSnapshot) {
                print('Teacher ListView built: courses index $index');
                print(documentSnapshot.toJson);
                Course course = Course.fromJson(documentSnapshot.toJson);
                return CourseListItem(
                  course: course,
                  onPressed: () =>
                      Navigator.push(context, CoursePage.route(course.id)),
                );
              },
              query: _getQuery(teacherId),
              emptyDisplay: _buildEmptyDisplay(context),
            ),
          ),
        ],
      ),
    );
  }

  Query _getQuery(String teacherId) =>
      FirestoreService.instance.getCoursesForTeacher(teacherId);

  Widget _buildEmptyDisplay(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 64,
        ),
        alignment: Alignment.center,
        child: Text(
          S.of(context).no_courses_for_teacher,
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}

class CourseListItem extends StatelessWidget {
  final Course course;

  final Function onPressed;

  final Color itemColor = Colors.primaries[Random().nextInt(
    Colors.primaries.length,
  )];

  final bool isAdmin;

  CourseListItem(
      {@required this.course, @required this.onPressed, this.isAdmin = false});

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
                      course.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${S.of(context).semester} : ${course.semester}',
                            style: Theme.of(context).textTheme.caption.apply(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              isAdmin
                  ? PopupMenuButton<int>(
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
                        final bloc = BlocProvider.of<AdminBloc>(context);
                        if (result == 0) {
                          await showPrimaryDialog<User>(
                            context: context,
                            dialog: BlocProvider.value(
                              value: bloc,
                              child: AddEditCourse(course: course),
                            ),
                          );
                        } else {
                          await showPrimaryDialog(
                            context: context,
                            dialog: BlocProvider.value(
                              value: bloc,
                              child: DeleteCourseDialog(
                                course: course,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
