import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/global.dart';
import '../../teacher/pages/search_page.dart';
import 'add_edit_user.dart';
import 'add_useres.dart';
import 'user_details.dart';

class ManageTeachersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButton(
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              '${S.of(context).manage} ${S.of(context).theTeachers}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchPage(),
                  );
                },
              ),
            ],
          ),
          body: PaginateFirestore(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 100,
            ),
            header: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                S.of(context).allTeachers,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            physics: BouncingScrollPhysics(),
            isLive: true,
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (index, context, documentSnapshot) {
              print('Items ListView built: item index $index');
              print(documentSnapshot.toJson);
              User user = User.fromJson(documentSnapshot.toJson);
              return UserListItem(
                user,
                onPressed: () {
                  final bloc = BlocProvider.of<AdminBloc>(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return BlocProvider.value(
                          value: bloc,
                          child: UserDetails(user: user),
                        );
                      },
                    ),
                  );
                },
                isAdmin: true,
              );
            },
            query: _getQuery(),
            emptyDisplay: _buildEmptyDisplay(),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                onPressed: () async {
                  final bloc = BlocProvider.of<AdminBloc>(context);
                  await showPrimaryDialog(
                    context: context,
                    dialog: BlocProvider.value(
                      value: bloc,
                      child: AddEditUser(
                        addingTeacher: true,
                      ),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(S.of(context).addTeacher),
                icon: Icon(Icons.add),
                heroTag: null,
              ),
              SizedBox(
                height: 8,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  final bloc = BlocProvider.of<AdminBloc>(context);
                  await showPrimaryDialog(
                    context: context,
                    dialog: BlocProvider.value(
                      value: bloc,
                      child: AddUsers(
                        isTeachers: true,
                      ),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(S.of(context).addTeachers),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  Query _getQuery() => FirestoreService.instance.getUsersWithRole('teacher');

  Widget _buildEmptyDisplay() {
    return Container();
  }
}
