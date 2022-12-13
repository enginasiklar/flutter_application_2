
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeRangeWidget extends StatelessWidget {

  const GaugeRangeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 33, color: Colors.green),
          GaugeRange(startValue: 33, endValue: 66, color: Colors.orange),
          GaugeRange(startValue: 66, endValue: 100, color: Colors.red)
        ], pointers: const <GaugePointer>[
          NeedlePointer(value: 85)
        ], annotations: const <GaugeAnnotation>[
          GaugeAnnotation(
              widget: Text('Strong Buy',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              angle: 90,
              positionFactor: 0.5)
        ])
      ]))),
    );
  }
}
