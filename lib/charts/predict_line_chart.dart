import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/line_model.dart';

class PredictLineDataWidget extends StatelessWidget {
  final List<LineData> points;
  final bool showCloseData;

  PredictLineDataWidget({required this.points, this.showCloseData = true ,  super.key});
final _zoomPanBehavior = ZoomPanBehavior(
  enablePinching: true,
  zoomMode: ZoomMode.x,
  enablePanning: true,
);

@override
Widget build(BuildContext context) {
  List<LineData> lastSevenDaysData = points.sublist(points.length - 7, points.length);
  List<ChartSeries> series = [
    LineSeries<LineData, String>(
      dataSource: lastSevenDaysData,
      xValueMapper: (LineData data, _) => data.date,
      yValueMapper: (LineData data, _) => data.prediction,
    ),
  ];
  if (showCloseData) {
    series.add(
      LineSeries<LineData, String>(
        dataSource: lastSevenDaysData,
        xValueMapper: (LineData data, _) => data.date,
        yValueMapper: (LineData data, _) => data.close,
      ),
    );
  }
  return Container(
    height: 300,
    child: SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: CategoryAxis(),
      series: series,
    ),
  );
}
}

