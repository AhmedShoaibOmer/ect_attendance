import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../generated/l10n.dart';

class AllLecturesStatsPage extends StatefulWidget {
  final Course course;
  final List<Lecture> lectures;

  AllLecturesStatsPage({
    @required this.course,
    @required this.lectures,
  });

  static route({
    @required Course course,
    @required List<Lecture> lectures,
  }) =>
      MaterialPageRoute(
        builder: (context) => AllLecturesStatsPage(
          course: course,
          lectures: lectures,
        ),
      );

  @override
  _AllLecturesStatsPageState createState() => _AllLecturesStatsPageState();
}

class _AllLecturesStatsPageState extends State<AllLecturesStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          S.of(context).all_lectures_stats,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildDefaultBarChart(),
      ),
    );
  }

  SfCartesianChart _buildDefaultBarChart() {
    return SfCartesianChart(
      margin: EdgeInsets.only(top: 32, right: 16, left: 16, bottom: 24),
      palette: [
        Colors.green,
        Colors.orange,
        Colors.red,
      ],
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
      ),
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: '${S.of(context).lectures} - ${S.of(context).cases}',
        textStyle: TextStyle(color: Theme.of(context).primaryColor),
      ),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
      ),
      series: _getDefaultBarSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the barchart.
  List<BarSeries<ChartData, String>> _getDefaultBarSeries() {
    final List<ChartData> chartData = widget.lectures
        .map(
          (e) => ChartData(
              x: e.name,
              y: e.attendeesIds.length,
              secondSeriesYValue: e.excusedAbsenteesIds.length,
              thirdSeriesYValue: e.absentIds.length),
        )
        .toList();

    return <BarSeries<ChartData, String>>[
      BarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: S.of(context).presence),
      BarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.secondSeriesYValue,
          name: S.of(context).excused_absence),
      BarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.thirdSeriesYValue,
          name: S.of(context).absence)
    ];
  }
}

///Chart data
class ChartData {
  /// Holds the datapoint values like x, y, etc.,
  ChartData({
    this.x,
    this.y,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds y value of the datapoint(for 2nd series)
  final num secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num thirdSeriesYValue;
}
