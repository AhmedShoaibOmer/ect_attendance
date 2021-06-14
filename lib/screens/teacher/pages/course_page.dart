import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/screens/teacher/pages/student_details_for_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/widgets.dart';
import 'add_edit_lecture_dialog.dart';
import 'all_lectures_stats_page.dart';
import 'all_students_stats_page.dart';
import 'edit_student_status_dialog.dart';
import 'lecture_page.dart';
import 'search_page.dart';

class CoursePage extends StatefulWidget {
  static route(String courseId) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => CourseBloc(
            courseRepository: RepositoryProvider.of(context),
            lectureRepository: RepositoryProvider.of(context),
            userRepository: RepositoryProvider.of(context),
            courseId: courseId,
          ),
          child: CoursePage(),
        );
      },
    );
  }

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<Lecture> lectures;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is AttendanceExcelFileCreatedState) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
              context,
              AllStudentsStatsPage.route(
                excelFileEntity: state.excelFileEntity,
                fileName: state.course.name,
              ),
            );
          }
          if (state is AttendanceExcelFileCreationFailedState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).something_went_wrong),
              ),
            );
          }
        },
        builder: (context, state) {
          Widget view = Container();

          if (state is CourseLoadingState) {
            view = Center(child: CircularProgressIndicator());
          } else if (state.course != CourseEntity.empty) {
            return SafeArea(
              child: NestedScrollView(
                // Setting floatHeaderSlivers to true is required in order to float
                // the outer slivers over the inner scrollable.
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leading: BackButton(
                        color: Theme.of(context).primaryColor,
                      ),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        state.course.name,
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
                          onPressed: () async {
                            final students =
                                context.read<CourseBloc>().students;
                            final selectedResult = await showSearch(
                              context: context,
                              delegate: SearchPage(
                                lectures: lectures,
                                students: students,
                                courseId: state.course.id,
                              ),
                            );
                            if (selectedResult is LectureEntity) {
                              Navigator.push(
                                  context,
                                  LecturePage.route(
                                      lecture: selectedResult,
                                      courseBloc: BlocProvider.of(context)));
                            } else if (selectedResult is UserEntity) {
                              final result = await showPrimaryDialog(
                                context: context,
                                dialog: StudentDetailsForCourse(
                                  student: selectedResult,
                                  lectures: lectures,
                                ),
                              );
                              if (result != null) {
                                final bloc =
                                    BlocProvider.of<CourseBloc>(context);
                                await showPrimaryDialog(
                                  context: context,
                                  dialog: BlocProvider.value(
                                    value: bloc,
                                    child: EditStudentStatusDialog(
                                      student: selectedResult,
                                      initialStatus:
                                          _getStatus(result, selectedResult.id),
                                      lecture: result,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
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
                            if (result == 0) {
                              Navigator.push(
                                context,
                                AllLecturesStatsPage.route(
                                  course: state.course,
                                  lectures: lectures,
                                ),
                              );
                            } else {
                              _createExcelFile();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bar_chart,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      S.of(context).all_lectures_stats,
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
                                    Icons.list_alt,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      S.of(context).all_students_stats,
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
                      pinned: true,
                      forceElevated: innerBoxIsScrolled,
                    ),
                  ];
                },
                body: PaginateFirestore(
                  onLoaded: (paginationLoaded) {
                    lectures = paginationLoaded.documentSnapshots
                        .map(
                          (e) => Lecture.fromJson(e.toJson),
                        )
                        .toList();
                  },
                  header: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      S.of(context).lectures,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  physics: BouncingScrollPhysics(),
                  itemBuilderType: PaginateBuilderType.listView,
                  itemBuilder: (index, context, documentSnapshot) {
                    print('Course ListView built: Lectures index $index');
                    print(documentSnapshot.toJson);
                    Lecture lecture = Lecture.fromJson(documentSnapshot.toJson);
                    return LectureListItem(
                      lecture: lecture,
                      courseId: state.course.id,
                      onPressed: () => Navigator.push(
                          context,
                          LecturePage.route(
                              lecture: lecture,
                              courseBloc: BlocProvider.of(context))),
                    );
                  },
                  query: _getQuery(state.course.id),
                  emptyDisplay: _buildEmptyDisplay(),
                ),
              ),
            );
          }

          return view;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading
            ? null
            : () async {
                final bloc = BlocProvider.of<CourseBloc>(context);
                await showPrimaryDialog(
                  context: context,
                  dialog: BlocProvider.value(
                    value: bloc,
                    child: AddEditLecture(),
                  ),
                );
              },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(S.of(context).add_lecture),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 64,
      ),
      alignment: Alignment.center,
      child: Text(
        S.of(context).no_lectures,
        style: TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  Query _getQuery(String courseId) =>
      FirestoreService.instance.lecturesForCourse(courseId: courseId);

  StudentStatus _getStatus(Lecture lecture, String id) {
    if (lecture.absentIds.contains(id))
      return StudentStatus.absent;
    else if (lecture.excusedAbsenteesIds.contains(id))
      return StudentStatus.absentWithExcuse;
    else
      return StudentStatus.present;
  }

  void _createExcelFile() async {
    final tempDir = await getTemporaryDirectory();
    context.read<CourseBloc>().add(CreateAttendanceExcelFileEvent(
          lectures: lectures,
          directoryPath: tempDir.path,
          nameColumnLabel: S.of(context).name,
          studentIdColumnLabel: S.of(context).student_id,
          lectureColumnLabel: S.of(context).lecture,
          attendancePercentColumnLabel: S.of(context).attendance_percent,
          excusedAbsencePercentColumnLabel:
              S.of(context).excused_absence_percent,
          absencePercentColumnLabel: S.of(context).absence_percent,
          presentTextValue: S.of(context).present,
          absentTextValue: S.of(context).absent,
          excusedAbsentTextValue: S.of(context).absent_with_excuse,
        ));
  }
}
