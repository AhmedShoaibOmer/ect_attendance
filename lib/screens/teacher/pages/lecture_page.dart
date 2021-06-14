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

class LecturePage extends StatefulWidget {
  final Lecture lecture;
  final CourseBloc courseBloc;

  static route({
    @required Lecture lecture,
    @required CourseBloc courseBloc,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: courseBloc,
          child: LecturePage(
            lecture: lecture,
          ),
        ),
      );

  LecturePage({
    this.lecture,
    this.courseBloc,
  });

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  Lecture lecture;

  @override
  void initState() {
    super.initState();
    lecture = widget.lecture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // Setting floatHeaderSlivers to true is required in order to float
        // the outer slivers over the inner scrollable.
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: BackButton(
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                lecture.name,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        courseId: context.read<CourseBloc>().course.id,
                        lectureId: lecture.id,
                      ),
                    );
                  },
                ),
                LecturePopupMenu(
                  lecture: lecture,
                  popAfterDelete: true,
                  onLectureUpdated: (lecture) {
                    setState(() {
                      this.lecture = lecture;
                    });
                  },
                ),
              ],
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            final studentsIds =
                context.select((CourseBloc cb) => cb.state.course.studentsIds);
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildDefaultDoughnutChart(studentsIds),
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
                  FutureBuilder<List<User>>(
                    future: FirestoreService.instance.getUsers(studentsIds),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _buildEmptyDisplay();
                      } else if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.isEmpty) {
                        return _buildEmptyDisplay();
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final student = snapshot.data[index];
                            return StudentListItem(
                              student: student,
                              status: _getStatus(student.id),
                              lecture: lecture,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 64,
        horizontal: 64,
      ),
      alignment: Alignment.center,
      child: Text(
        S.of(context).thereAreNoStudentsStudyingThisCourse,
        style: TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  /// Return the circular chart with default doughnut series.
  Widget _buildDefaultDoughnutChart(List<String> studentsIds) {
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
        series: _getDefaultDoughnutSeries(studentsIds),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  /// Returns the doughnut series which need to be render.
  List<DoughnutSeries<ChartData, String>> _getDefaultDoughnutSeries(
      List<String> studentsIds) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(
        x: S.of(context).presence,
        y: lecture.attendeesIds.length,
        text: '${(lecture.attendeesIds.length / studentsIds.length) * 100}%',
      ),
      ChartData(
        x: S.of(context).excused_absence,
        y: lecture.excusedAbsenteesIds.length,
        text:
            '${(lecture.excusedAbsenteesIds.length / studentsIds.length) * 100}%',
      ),
      ChartData(
        x: S.of(context).absence,
        y: lecture.absentIds.length,
        text: '${(lecture.absentIds.length / studentsIds.length) * 100}%',
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

  StudentStatus _getStatus(String id) {
    if (lecture.absentIds.contains(id))
      return StudentStatus.absent;
    else if (lecture.excusedAbsenteesIds.contains(id))
      return StudentStatus.absentWithExcuse;
    else
      return StudentStatus.present;
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
      default:
        return S.of(context).present;
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
