import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/predict_grid/predict_grid_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

import '../../model/predictions_short_data.dart';

// ignore: must_be_immutable
class PredectionsGridView extends StatelessWidget {
  PredectionsGridView({super.key});
  List<PredictGrid> data = PredictGrid.getData();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future:
              PredictionsShortData.getChangedValue(data[index].stock.ticker),
          initialData: '#',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Color color;
            if (snapshot.data.toString().contains("#")) {
              color = PredictGrid.blue;
            } else {
              if (snapshot.data.toString().contains("-")) {
                color = PredictGrid.red;
              } else {
                color = PredictGrid.green;
              }
            }
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
                color: color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data[index].name),
                    Text(snapshot.data),
                    // PredictionsShortData.getChangeLastMonth(
                    //     data[index].stock.ticker, false)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
