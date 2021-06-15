import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/utilities.dart';

class AddEditUser extends StatefulWidget {
  final User user;
  final bool addingTeacher;

  const AddEditUser({Key key, this.user, this.addingTeacher}) : super(key: key);

  @override
  _AddEditUserState createState() => _AddEditUserState();
}

class _AddEditUserState extends State<AddEditUser> {
  String name;

  String role;

  String departmentId;

  String id;

  int semester;

  bool isUpdating = false;

  bool isTeacher = false;

  User updatedUser;

  List<Department> departments = [];

  @override
  void initState() {
    super.initState();

    FirestoreService.instance.getDepartments().get().then(
          (value) => setState(() {
            departments.addAll(
              value.docs
                  .map(
                    (e) => Department.fromJson(e.toJson),
                  )
                  .toList(),
            );
          }),
        );

    if (widget.user != null) {
      isUpdating = true;
      name = widget.user.name;
      departmentId = widget.user.departmentId;
      id = widget.user.id;
      semester = widget.user.semester;
      isTeacher = widget.user.isTeacher;
      role = widget.user.role;
    } else
      isTeacher = widget.addingTeacher;

    if (isTeacher) {
      semester = 0;
      role = 'teacher';
    } else {
      role = 'student';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BlocConsumer<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is UserAddingEditingFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).operation_failed),
                  ),
                );
              } else if (state is UseraAddedEditedState) {
                Navigator.pop(context, updatedUser);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).userSavedSuccessfully),
                  ),
                );
              } else if (state is NoInternetConnectionState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).no_connection_error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  children: <Widget>[
                    Text(
                      isUpdating
                          ? S.of(context).editUser
                          : S.of(context).addUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isUpdating ? Container() : SizedBox(height: 30.0),
                    isUpdating ? Container() : _buildIdTF(),
                    SizedBox(height: 30.0),
                    _buildNameTF(),
                    !isTeacher ? SizedBox(height: 30.0) : Container(),
                    !isTeacher ? _buildSemesterDropdown() : Container(),
                    SizedBox(height: 30.0),
                    _buildTypeDropdown(),
                    SizedBox(height: 30.0),
                    _buildDepartmentDropdown(),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () => _onPressed(context),
                            child: Text(S.of(context).save),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextButton(
                            child: Text(
                              S.of(context).cancel,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) async {
    if (name != null &&
        name.isNotEmpty &&
        role != null &&
        role.isNotEmpty &&
        id != null &&
        id.isNotEmpty &&
        departmentId != null &&
        departmentId.isNotEmpty &&
        semester != null) {
      if (isUpdating) {
        if (widget.user.name != name ||
            widget.user.role != role ||
            widget.user.departmentId != departmentId ||
            widget.user.semester != semester) {
          updatedUser = widget.user.copyWith(
            name: name,
            role: role,
            semester: semester,
            departmentId: departmentId,
          );
          context.read<AdminBloc>().add(
                AddEditUserEvent(updatedUser),
              );
        } else {
          Navigator.pop(context);
        }
      } else {
        final user = User(
            id: id,
            name: name,
            role: role,
            departmentId: departmentId,
            semester: semester);
        context.read<AdminBloc>().add(
              AddEditUserEvent(user),
            );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).all_fields_are_required),
        ),
      );
    }
  }

  Widget _buildIdTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).userId,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: TextField(
            onChanged: (value) {
              id = value;
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsetsDirectional.only(start: 14.0),
              hintText: S.of(context).enterTheUserId,
              hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).userName,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: TextField(
            controller: isUpdating
                ? TextEditingController(text: widget.user.name)
                : null,
            onChanged: (value) {
              name = value;
            },
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsetsDirectional.only(start: 14.0),
              hintText: S.of(context).enterTheFullUserName,
              hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).semester,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<int>(
              value: widget.addingTeacher == null ? semester : 1,
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (int newValue) {
                setState(() {
                  semester = newValue;
                });
              },
              items: List.generate(
                  10,
                  (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text(
                          (index + 1).toString(),
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).userType,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: widget.addingTeacher == null
                  ? role
                  : widget.addingTeacher
                      ? 'teacher'
                      : 'student',
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              onChanged: widget.addingTeacher == null
                  ? (String newValue) {
                      setState(() {
                        role = newValue;
                      });
                    }
                  : null,
              items: [
                DropdownMenuItem<String>(
                  value: 'student',
                  child: Text(
                    S.of(context).student.toUpperCase(),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'teacher',
                  child: Text(
                    S.of(context).teacher.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).department,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: departmentId,
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (String newValue) {
                setState(() {
                  departmentId = newValue;
                });
              },
              items: departments
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e.id,
                      child: Text(
                        e.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
