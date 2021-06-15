import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:ect_attendance/screens/teacher/teacher_home_screen.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets.dart';

class SearchPage extends SearchDelegate {
  final String scope;
  QuerySnapshot querySnaps;

  SearchPage({
    @required this.scope,
  }) {
    if (scope == 'student' || scope == 'teacher') {
      FirestoreService.instance
          .getUsersWithRole(scope)
          .get()
          .then((value) => querySnaps = value);
    } else if (scope == 'courses') {
      FirestoreService.instance
          .getCourses()
          .get()
          .then((value) => querySnaps = value);
    } else {
      FirestoreService.instance
          .getDepartments()
          .get()
          .then((value) => querySnaps = value);
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<List<Widget>> getResults(QuerySnapshot querySnapshot) async {
      final List<Widget> results = [];

      if (querySnapshot != null) {
        List<QueryDocumentSnapshot> docs = querySnapshot.docs;

        if (scope == 'courses') {
          final List<Course> courses =
              docs.map((e) => Course.fromJson(e.toJson)).toList();
          courses.forEach(
            (element) {
              if (element.name.toLowerCase().contains(query.toLowerCase())) {
                results.add(
                  CourseListItem(
                    isAdmin: true,
                    onPressed: () => close(context, element),
                    course: element,
                  ),
                );
              }
            },
          );
        } else {
          final List<User> users =
              docs.map((e) => User.fromJson(e.toJson)).toList();

          users.forEach(
            (element) {
              if (element.id.toLowerCase().contains(query.toLowerCase()) ||
                  element.name.toLowerCase().contains(query.toLowerCase())) {
                results.add(
                  UserListItem(
                    element,
                    isAdmin: true,
                    onPressed: () {
                      close(context, element);
                    },
                  ),
                );
              }
            },
          );
        }
      }
      return results;
    }

    return FutureBuilder<List<Widget>>(
      future: getResults(querySnaps),
      builder: (context, snapshot) {
        if (query == null || query.isEmpty || query.length < 3)
          return Center(
            child: Text(S.of(context).typeMoreThanTwoCharacters),
          );

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: 24,
              ),
              physics: BouncingScrollPhysics(),
              children: snapshot.data,
            );
          } else {
            return Center(
              child: Text(S.of(context).noDataFound),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
