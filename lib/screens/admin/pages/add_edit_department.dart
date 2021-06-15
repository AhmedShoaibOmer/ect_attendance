import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';

class AddEditDepartment extends StatefulWidget {
  final Department department;

  const AddEditDepartment({Key key, this.department}) : super(key: key);

  @override
  _AddEditDepartmentState createState() => _AddEditDepartmentState();
}

class _AddEditDepartmentState extends State<AddEditDepartment> {
  String name;

  bool isUpdating = false;

  Department updatedDepartment;

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      isUpdating = true;
      name = widget.department.name;
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
              if (state is DepartmentAddingEditingFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).operation_failed),
                  ),
                );
              } else if (state is DepartmentAddedEditedState) {
                Navigator.pop(context, updatedDepartment);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).departmentSavedSuccessfully),
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
                          ? S.of(context).editDepartment
                          : S.of(context).addDepartment,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    _buildNameTF(),
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
    if (name != null && name.isNotEmpty) {
      if (isUpdating) {
        if (widget.department.name != name) {
          updatedDepartment = widget.department.copyWith(
            name: name,
          );
          context.read<AdminBloc>().add(
                AddEditDepartmentEvent(updatedDepartment),
              );
        } else {
          Navigator.pop(context);
        }
      } else {
        final department = Department(id: '', name: name);
        context.read<AdminBloc>().add(
              AddEditDepartmentEvent(department),
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
          S.of(context).departmentName,
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
                ? TextEditingController(text: widget.department.name)
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
              hintText: S.of(context).enterTheFullDepartmentName,
              hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }
}
