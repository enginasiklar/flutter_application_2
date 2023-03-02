import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/predict_grid/predict_grid_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

import '../../model/predictions_short_data.dart';

//TODO: make colors dynamic
class PredectionsGridView extends StatelessWidget {
  PredectionsGridView({super.key});
  List<PredectGrid> data = PredectGrid.getData();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              // return const stockPage();
              return StockPage(
                stockCode: data[index].stock.ticker,
                stockName: data[index].stock.name,
              );
            }));
          },
          child: Card(
            margin: const EdgeInsets.all(5),
            color: data[index].color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data[index].name),
                // Text("${data[index].precentage} %"),
                PredictionsShortData.getChangeLastMonth(
                    data[index].stock.ticker, false)
              ],
            ),
          ),
        );
      },
    );
  }
}
