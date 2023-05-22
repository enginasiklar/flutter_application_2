import 'package:flutter/material.dart';

import '../../model/main_model.dart';
import '../../model/stock_model.dart';

class StocksGrid {
  final String name;
  final double percentage;
  final Color color;
  final Stock stock;
  StocksGrid(this.name, this.percentage, this.color, this.stock);
  static const Color green = Color.fromARGB(200, 76, 175, 79);
  static const Color red = Color.fromARGB(200, 244, 67, 54);
  static Color blue = Colors.blue.shade200;
  static List<StocksGrid> getData(Map<String, MainModel> mainData) {
    List<StocksGrid> data = [];
    mainData.forEach((key, value) {
      double percentage = ((value.todayValue - value.yesterdayValue) / value.yesterdayValue) * 100;
      Color color = percentage >= 0 ? green : red;
      Stock stock = Stock.stockList.firstWhere((stock) => stock.ticker == key);
      data.add(StocksGrid(stock.name, percentage, color, stock));
    });    return data; }}


