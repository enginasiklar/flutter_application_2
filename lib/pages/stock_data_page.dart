import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model/main_model.dart';

class StockDataPage extends StatelessWidget {
  final String stockCode;

  const StockDataPage(this.stockCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainModel =
        MainModel.data.values.firstWhere((model) => model.name == stockCode);
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tr("stockData.todayValue",
                      args: [todayValue.toStringAsFixed(2)]),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tr("stockData.percentDiffDay", args: [
                    ((todayValue - yesterdayValue) / yesterdayValue * 100)
                        .toStringAsFixed(2)
                  ]),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tr("stockData.percentDiffMonth", args: [
                    ((0 - lastMonthValue) / lastMonthValue * 100)
                        .toStringAsFixed(2)
                  ]),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
