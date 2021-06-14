import 'dart:math';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../generated/l10n.dart';
import '../screens/admin/pages/add_edit_user.dart';
import '../screens/admin/pages/delete_user_dialog.dart';
import '../utilities/global.dart';

class UserListItem extends StatelessWidget {
  final Color itemColor = Colors.primaries[Random().nextInt(
    Colors.primaries.length,
  )];
  final User user;

  final bool isAdmin;

  final Function onPressed;

  UserListItem(
    this.user, {
    this.isAdmin = false,
    @required this.onPressed,
  });

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
                      user.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'ID: ${user.id}',
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
                              child: AddEditUser(
                                user: user,
                              ),
                            ),
                          );
                        } else {
                          await showPrimaryDialog(
                            context: context,
                            dialog: BlocProvider.value(
                              value: bloc,
                              child: DeleteUserDialog(
                                user: user,
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
