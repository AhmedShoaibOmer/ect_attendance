import 'dart:math';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ect_attendance/screens/teacher/pages/qr_generate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../generated/l10n.dart';
import '../../../utilities/global.dart';
import '../../../widgets/widgets.dart';
import 'edit_student_status_dialog.dart';

enum StudentStatus { absent, absentWithExcuse, present }

class LecturePage extends StatelessWidget {
  final String lectureId;
  final String courseId;
  final CourseBloc courseBloc;

  static route({
    @required String lectureId,
    @required String courseId,
    @required CourseBloc courseBloc,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: courseBloc,
          child: LecturePage(
            lectureId: lectureId,
            courseId: courseId,
          ),
        ),
      );

  LecturePage({
    this.lectureId,
    this.courseId,
    this.courseBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          return StreamBuilder<Lecture>(
            stream: FirestoreService.instance.lecture(lectureId, courseId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Center(child: const CircularProgressIndicator());
                  break;
                default:
                  return NestedScrollView(
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
                          title: Text(
                            snapshot.data.name,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          elevation: 0,
                          pinned: true,
                          forceElevated: innerBoxIsScrolled,
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.qr_code,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {
                                await showPrimaryDialog(
                                  context: context,
                                  dialog: QRGenerateDialog(
                                    courseId:
                                        context.read<CourseBloc>().course.id,
                                    lectureId: snapshot.data.id,
                                  ),
                                );
                              },
                            ),
                            LecturePopupMenu(
                              lecture: snapshot.data,
                              popAfterDelete: true,
                              onLectureUpdated: (lecture) {},
                            ),
                          ],
                        ),
                      ];
                    },
                    body: Builder(
                      builder: (context) {
                        final students =
                            context.select((CourseBloc cb) => cb.students);
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildDefaultDoughnutChart(
                                context,
                                students.map((e) => e.id).toList(),
                                snapshot.data,
                              ),
                              Container(
                                height: 56,
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    S.of(context).studentsList,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ]..addAll(students
                                .map((e) => StudentListItem(
                                      student: e,
                                      status: _getStatus(e.id, snapshot.data),
                                      lecture: snapshot.data,
                                    ))
                                .toList()),
                          ),
                        );
                      },
                    ),
                  );
                  break;
              }
            },
          );
        },
      ),
    );
  }

  /// Return the circular chart with default doughnut series.
  Widget _buildDefaultDoughnutChart(
      BuildContext context, List<String> studentsIds, Lecture lecture) {
    return Container(
      height: 150,
      width: double.infinity,
      child: SfCircularChart(
        palette: [
          Colors.green,
          Colors.orange,
          Colors.red,
        ],
        title: ChartTitle(),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: _getDefaultDoughnutSeries(context, studentsIds, lecture),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  /// Returns the doughnut series which need to be render.
  List<DoughnutSeries<ChartData, String>> _getDefaultDoughnutSeries(
      BuildContext context, List<String> studentsIds, Lecture lecture) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(
        x: S.of(context).presence,
        y: lecture.attendeesIds.length,
        text:
            '${((lecture.attendeesIds.length / studentsIds.length) * 100).round()}%',
      ),
      ChartData(
        x: S.of(context).excused_absence,
        y: lecture.excusedAbsenteesIds.length,
        text:
            '${((lecture.excusedAbsenteesIds.length / studentsIds.length) * 100).round()}%',
      ),
      ChartData(
        x: S.of(context).absence,
        y: lecture.absentIds.length,
        text:
            '${((lecture.absentIds.length / studentsIds.length) * 100).round()}%',
      ),
    ];
    return <DoughnutSeries<ChartData, String>>[
      DoughnutSeries<ChartData, String>(
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ];
  }

  StudentStatus _getStatus(String id, Lecture lecture) {
    if (lecture.attendeesIds.contains(id))
      return StudentStatus.present;
    else if (lecture.excusedAbsenteesIds.contains(id))
      return StudentStatus.absentWithExcuse;
    else
      return StudentStatus.absent;
  }
}

class StudentListItem extends StatelessWidget {
  final Color itemColor = Colors.primaries[Random().nextInt(
    Colors.primaries.length,
  )];

  final User student;
  final StudentStatus status;
  final Lecture lecture;

  StudentListItem({
    Key key,
    this.student,
    this.status,
    this.lecture,
  }) : super(key: key);

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
      onPressed: () async {
        final bloc = BlocProvider.of<CourseBloc>(context);
        await showPrimaryDialog(
          context: context,
          dialog: BlocProvider.value(
            value: bloc,
            child: EditStudentStatusDialog(
              student: student,
              initialStatus: status,
              lecture: lecture,
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 500,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                width: 8,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
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
                      student.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: _statusColor(),
                          size: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Text(
                            _statusText(context),
                            style: Theme.of(context).textTheme.caption.apply(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(BuildContext context) {
    switch (status) {
      case StudentStatus.absent:
        return S.of(context).absent;
      case StudentStatus.absentWithExcuse:
        return S.of(context).absent_with_excuse;
      case StudentStatus.present:
        return S.of(context).present;
      default:
        return S.of(context).absent;
    }
  }

  Color _statusColor() {
    switch (status) {
      case StudentStatus.absent:
        return Colors.red;
      case StudentStatus.absentWithExcuse:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}

///Chart data
class ChartData {
  /// Holds the datapoint values like x, y, etc.,
  ChartData({
    this.x,
    this.y,
    this.text,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  final String text;
}
