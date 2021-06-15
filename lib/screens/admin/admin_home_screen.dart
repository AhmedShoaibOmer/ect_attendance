import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';
import '../../widgets/widgets.dart';
import 'pages/manage_courses_page.dart';
import 'pages/manage_departments_page.dart';
import 'pages/manage_students_page.dart';
import 'pages/manage_teachers_page.dart';

class AdminHomeScreen extends StatefulWidget {
  static get route => MaterialPageRoute(
        builder: (context) {
          return AdminHomeScreen();
        },
      );

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      child: GridView.extent(
        maxCrossAxisExtent: 200,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24),
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        children: [
          buildManageButton(
            context,
            title: S.of(context).theTeachers.toUpperCase(),
            page: ManageTeachersPage(),
          ),
          buildManageButton(
            context,
            title: S.of(context).theStudents.toUpperCase(),
            page: ManageStudentsPage(),
          ),
          buildManageButton(
            context,
            title: S.of(context).theCourses.toUpperCase(),
            page: ManageCoursesPage(),
          ),
          buildManageButton(
            context,
            title: S.of(context).theDepartments.toUpperCase(),
            page: ManageDepartmentsPage(),
          ),
        ],
      ),
    );
  }

  TextButton buildManageButton(BuildContext context,
      {@required String title, @required Widget page}) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey.shade50),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      onPressed: () => onPressed(page),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.construction,
            size: 100,
          ),
          Flexible(
            child: Text(
              '${S.of(context).manage.toUpperCase()} $title',
            ),
          )
        ],
      ),
    );
  }

  void onPressed(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (_) => AdminBloc(
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
            ),
            child: page,
          );
        },
      ),
    );
  }
}
