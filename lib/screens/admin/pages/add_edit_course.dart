import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';

class AddEditCourse extends StatefulWidget {
  final Course course;

  const AddEditCourse({Key key, this.course}) : super(key: key);

  @override
  _AddEditCourseState createState() => _AddEditCourseState();
}

class _AddEditCourseState extends State<AddEditCourse> {
  String name;

  int semester;

  String teacherId;

  String departmentId;

  bool isUpdating = false;

  Course updatedCourse;

  List<Department> departments = [];

  List<User> teachers = [];

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

    FirestoreService.instance.getUsersWithRole('teacher').get().then(
          (value) => setState(() {
            teachers.addAll(
              value.docs
                  .map(
                    (e) => User.fromJson(e.toJson),
                  )
                  .toList(),
            );
          }),
        );

    if (widget.course != null) {
      isUpdating = true;
      name = widget.course.name;
      semester = widget.course.semester;
      departmentId = widget.course.departmentId;
      teacherId = widget.course.teacherId;
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
              if (state is CourseAddingEditingFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).operation_failed),
                  ),
                );
              } else if (state is CourseAddedEditedState) {
                Navigator.pop(context, updatedCourse);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).courseSavedSuccessfully),
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
                          ? S.of(context).editCourse
                          : S.of(context).addCourse,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    _buildNameTF(),
                    SizedBox(height: 30.0),
                    _buildTeacherDropdown(),
                    SizedBox(height: 30.0),
                    _buildSemesterDropdown(),
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
        teacherId != null &&
        teacherId.isNotEmpty &&
        departmentId != null &&
        semester != null &&
        departmentId.isNotEmpty) {
      if (isUpdating) {
        if (widget.course.name != name ||
            widget.course.teacherId != teacherId ||
            widget.course.departmentId != departmentId ||
            widget.course.semester != semester) {
          updatedCourse = widget.course.copyWith(
            name: name,
            teacherId: teacherId,
            departmentId: departmentId,
            semester: semester,
          );
          context.read<AdminBloc>().add(
                AddEditCourseEvent(updatedCourse),
              );
        } else {
          Navigator.pop(context);
        }
      } else {
        final course = Course(
          id: '',
          name: name,
          teacherId: teacherId,
          departmentId: departmentId,
          semester: semester,
        );
        context.read<AdminBloc>().add(
              AddEditCourseEvent(course),
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

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).courseName,
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
                ? TextEditingController(text: widget.course.name)
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

  Widget _buildTeacherDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).teacher,
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
              value: teacherId,
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
                  teacherId = newValue;
                });
              },
              items: teachers
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
              value: null,
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
