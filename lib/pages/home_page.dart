import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/bar_chart_page.dart';
import 'package:flutter_application_2/pages/gauge_range_page.dart';
import 'package:flutter_application_2/pages/line_chart_page.dart';
import 'package:flutter_application_2/pages/predict_line_chart_page.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.stacked_line_chart),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
          ]),
        ),
        backgroundColor: Colors.amber[40],
        body: TabBarView(children: [
          const LineChartPage(),
          const BarChartPage(),
          GaugeRangePage(),
          const PredictLineDataPage(),
          const stockPage(),
        ]),
      ),
    );
  }
}
