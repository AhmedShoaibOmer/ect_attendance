import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets.dart';

class SearchPage extends SearchDelegate {
  final List<UserEntity> students;
  final List<LectureEntity> lectures;
  final String courseId;

  SearchPage({
    @required this.students,
    @required this.lectures,
    @required this.courseId,
  });

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
    if (query == null || query.isEmpty || query.length < 3)
      return Center(
        child: Text(S.of(context).typeMoreThanTwoCharacters),
      );

    Future<List<Widget>> getResults() async {
      final List<Widget> results = [];

      lectures.forEach(
        (element) {
          if (element.name.toLowerCase().contains(query.toLowerCase())) {
            results.add(
              LectureListItem(
                courseId: courseId,
                lecture: element,
                isSearchPage: true,
                onPressed: () => close(context, element),
              ),
            );
          }
        },
      );

      students.forEach(
        (element) {
          if (element.id.toLowerCase().contains(query.toLowerCase()) ||
              element.name.toLowerCase().contains(query.toLowerCase())) {
            results.add(
              UserListItem(
                element,
                onPressed: () {
                  close(context, element);
                },
              ),
            );
          }
        },
      );

      return results;
    }

    return FutureBuilder<List<Widget>>(
      future: getResults(),
      builder: (context, snapshot) {
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
