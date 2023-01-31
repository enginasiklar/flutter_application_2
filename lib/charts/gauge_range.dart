
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/gauge_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeRangeWidget extends StatelessWidget {
  final SentData points;
  const GaugeRangeWidget(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 33, color: Colors.red),
          GaugeRange(startValue: 33, endValue: 66, color: Colors.orange),
          GaugeRange(startValue: 66, endValue: 100, color: Colors.green)
        ], pointers: <GaugePointer>[NeedlePointer(value:  double.parse(points.value))
        ], annotations: <GaugeAnnotation>[GaugeAnnotation(widget: Text("${points.value} ${points.valueClassification}", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              angle: 90,
              positionFactor: 0.5)
        ])
      ]))),
    );
  }
}



