import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/main_model.dart';

class StockDataPage extends StatelessWidget {
  final String stockCode;

  const StockDataPage(this.stockCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainModel = MainModel.data.values.firstWhere((model) => model.name == stockCode);
    final double todayValue = mainModel.todayValue;
    final double yesterdayValue = mainModel.yesterdayValue;
    final double? lastMonthPred = mainModel.lastMonthPred;
    final double lastMonthValue = mainModel.lastMonthValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(stockCode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today Value: ${todayValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Percentage Change (Today vs Yesterday): ${((todayValue - yesterdayValue) / yesterdayValue * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Percentage Change (Last Month Prediction vs Last Month Value): ${((0 - lastMonthValue) / lastMonthValue * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
