import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/widgets.dart';

class AddEditLecture extends StatefulWidget {
  final Lecture lecture;

  const AddEditLecture({Key key, this.lecture}) : super(key: key);

  @override
  _AddEditLectureState createState() => _AddEditLectureState();
}

class _AddEditLectureState extends State<AddEditLecture> {
  DateTime selectedDate = DateTime.now();

  String name;

  bool isUpdating = false;

  Lecture updatedLecture;

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).lecture_name,
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
                ? TextEditingController(text: widget.lecture.name)
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
              hintText: S.of(context).lecture_name_hint,
              hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.lecture != null) {
      isUpdating = true;
      name = widget.lecture.name;
      selectedDate = widget.lecture.date;
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
          child: BlocConsumer<CourseBloc, CourseState>(
            listener: (context, state) {
              if (state is LectureCreationFailedState ||
                  state is LectureUpdateFailedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).operation_failed),
                  ),
                );
              } else if (state is LectureCreatedState ||
                  state is LectureUpdatedState) {
                Navigator.pop(context, updatedLecture);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).lecture_saved_successfully),
                  ),
                );
              } else if (state is NoConnectionState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).no_connection_error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CourseLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  children: <Widget>[
                    Text(
                      isUpdating
                          ? S.of(context).edit_lecture
                          : S.of(context).add_lecture,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    _buildNameTF(),
                    SizedBox(
                      height: 30.0,
                    ),
                    BasicDateTimeField(
                      onChanged: (value) {
                        selectedDate = value;
                      },
                      initialValue: selectedDate,
                    ),
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
                            child: Text(S.of(context).save.toUpperCase()),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextButton(
                            child: Text(
                              S.of(context).cancel.toUpperCase(),
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
    if (name != null && name.isNotEmpty && selectedDate != null) {
      if (isUpdating) {
        if (widget.lecture.name != name ||
            widget.lecture.date != selectedDate) {
          updatedLecture = widget.lecture.copyWith(
            name: name,
            date: selectedDate,
          );
          context.read<CourseBloc>().add(
                UpdateLectureEvent(updatedLecture),
              );
        } else {
          Navigator.pop(context);
        }
      } else {
        context.read<CourseBloc>().add(
              CreateNewLectureEvent(
                name: name,
                date: selectedDate,
              ),
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
}
