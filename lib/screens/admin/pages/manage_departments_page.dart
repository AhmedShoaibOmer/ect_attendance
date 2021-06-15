import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/global.dart';
import 'add_edit_department.dart';
import 'admin_search_page.dart';
import 'delete_department_dialog.dart';

class ManageDepartmentsPage extends StatelessWidget {
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
              '${S.of(context).manage} ${S.of(context).theDepartments}',
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
                    delegate: SearchPage(scope: 'departments'),
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
                S.of(context).allDepartments,
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
              Department department =
                  Department.fromJson(documentSnapshot.toJson);
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
                onPressed: null,
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
                            color: Colors.primaries[Random().nextInt(
                              Colors.primaries.length,
                            )],
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
                                department.name,
                                style:
                                    Theme.of(context).textTheme.subtitle1.apply(
                                          color: Theme.of(context).primaryColor,
                                        ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<int>(
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
                                  child:
                                      AddEditDepartment(department: department),
                                ),
                              );
                            } else {
                              await showPrimaryDialog(
                                context: context,
                                dialog: BlocProvider.value(
                                  value: bloc,
                                  child: DeleteDepartmentDialog(
                                    department: department,
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            query: _getQuery(),
            emptyDisplay: _buildEmptyDisplay(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final bloc = BlocProvider.of<AdminBloc>(context);
              await showPrimaryDialog(
                context: context,
                dialog: BlocProvider.value(
                  value: bloc,
                  child: AddEditDepartment(),
                ),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            label: Text(S.of(context).addDepartment),
            icon: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Query _getQuery() => FirestoreService.instance.getDepartments();

  Widget _buildEmptyDisplay() {
    return Container();
  }
}
