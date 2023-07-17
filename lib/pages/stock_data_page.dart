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
    final double? lastWeekPred = mainModel.lastWeekPred;
    final double lastWeekValue = mainModel.lastWeekValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(stockCode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mainModel.todayPred != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Predicted Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Predicted Price: ${mainModel.todayPred!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Value",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Value: ${todayValue.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (yesterdayValue != 0)
                      Text(
                        'Percentage Change (Today vs Yesterday): ${((todayValue - yesterdayValue) / yesterdayValue * 100).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (lastWeekPred != null && lastWeekValue != 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Week",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: ${lastWeekValue.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (lastWeekPred != 0)
                        Text(
                          'Predicted vs Actual Price Difference: ${(lastWeekValue - lastWeekPred).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (lastMonthPred != null && lastMonthValue != 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Month",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: ${lastMonthValue.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (lastMonthPred != 0)
                        Text(
                          'Predicted vs Actual Price Difference: ${(lastMonthValue - lastMonthPred) .toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



