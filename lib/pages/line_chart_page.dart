import 'package:flutter/material.dart';
import 'package:flutter_application_2/charts/line_chart.dart';
import 'package:flutter_application_2/price_points.dart';

class LineChartPage extends StatelessWidget {
  const LineChartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<List<PricePoint>>(
                future: getPricePoints(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()]);
                  }
                    return Column(children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: LineChartWidget(snapshot.data))
                    ]);

                })),
      ),
    );
  }
}

