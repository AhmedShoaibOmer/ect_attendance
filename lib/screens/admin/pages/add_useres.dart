import 'dart:io';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/widgets.dart';

class AddUsers extends StatefulWidget {
  final bool isTeachers;

  const AddUsers({Key key, this.isTeachers = false}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  String filePath;

  TextEditingController textController;

  bool isLoading = false;

  bool isTeachers;

  int semester;

  String departmentId;

  List<Department> departments = [];

  List<User> loadedUsers = [];

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

    textController = TextEditingController();
    isTeachers = widget.isTeachers;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(
              Radius.circular(10),
            ),
          ),
          child: BlocConsumer<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is UsersAddingFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(S.of(context).usersCreationFailedPleaseTryAgain),
                  ),
                );
              } else if (state is UsersaAddedState) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).usersSavedSuccessfully),
                  ),
                );
              } else if (state is NoNetworkConnectionState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).no_connection_error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSelectFileTF(),
                    SizedBox(
                      height: 24,
                    ),
                    _buildDepartmentDropdown(),
                    SizedBox(
                      height: 16,
                    ),
                    !isTeachers ? _buildSemesterDropdown() : Container(),
                    !isTeachers
                        ? SizedBox(
                            height: 16,
                          )
                        : Container(),
                    Divider(),
                    isLoading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : loadedUsers.isNotEmpty
                            ? Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 24,
                                  ),
                                  children: loadedUsers
                                      .map((e) =>
                                          UserListItem(e, onPressed: null))
                                      .toList(),
                                ),
                              )
                            : Container(),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: loadedUsers.isNotEmpty
                                ? () => _onPressed(context)
                                : null,
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
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ],
                );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).department,
            style: kLabelStyle.copyWith(color: Theme.of(context).primaryColor),
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
      ),
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
              value: semester,
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

  Widget _buildSelectFileTF() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).selectExcelFile,
            style: kLabelStyle.copyWith(color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle.copyWith(
              color: Colors.white,
            ),
            height: 56.0,
            child: TextField(
              readOnly: true,
              showCursor: true,
              controller: textController,
              onTap: readExcelFile,
              onChanged: (value) {
                filePath = value;
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsetsDirectional.only(start: 14.0),
                hintText: S.of(context).clickHereToSelectFile,
                hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void readExcelFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        isLoading = true;
        textController.text = file.path;
      });

      List<User> users = ExcelService.readUsersFromExcelFile(
        file.path,
        isTeachers,
      );

      setState(() {
        isLoading = false;
        loadedUsers.addAll(users);
      });
    } else {
      // User canceled the picker
    }
  }

  void _onPressed(BuildContext context) {
    if (loadedUsers.isNotEmpty &&
        departmentId != null &&
        departmentId.isNotEmpty) {
      context.read<AdminBloc>().add(AddUsersEvent(
            loadedUsers
                .map((e) => e.copyWith(
                      departmentId: departmentId,
                    ))
                .toList(),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).all_fields_are_required),
        ),
      );
    }
  }
}
