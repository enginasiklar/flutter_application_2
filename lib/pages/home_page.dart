import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/gauge_range_page.dart';
import 'package:flutter_application_2/pages/predict_grid/predections_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.multiline_chart_rounded),
            ),
            Tab(
              icon: Icon(Icons.crop_square_rounded),
            ),
          ]),
        ),
        backgroundColor: Colors.amber[40],
        body: TabBarView(children: [
          GaugeRangePage(),
          PredectionsGridView(),
        ]),
      ),
    );
  }
}
