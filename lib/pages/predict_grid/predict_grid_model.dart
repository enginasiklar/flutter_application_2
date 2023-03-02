import 'package:flutter/material.dart';

import '../../model/stock_model.dart';

class PredectGrid {
  final String name;
  final double precentage;
  final Color color;
  final Stock stock;
  PredectGrid(this.name, this.precentage, this.color, this.stock);
  static const Color green = Color.fromARGB(200, 76, 175, 79);
  static const Color red = Color.fromARGB(200, 244, 67, 54);
  static List<PredectGrid> getData() {
    List<PredectGrid> data = [
      PredectGrid(Stock.stockListShort[0], 10, green, Stock.stockList[0]),
      PredectGrid(Stock.stockListShort[1], -15, red, Stock.stockList[1]),
      PredectGrid(Stock.stockListShort[2], 20, green, Stock.stockList[2]),
      PredectGrid(Stock.stockListShort[3], -25, red, Stock.stockList[3]),
      PredectGrid(Stock.stockListShort[4], 30, green, Stock.stockList[4]),
      PredectGrid(Stock.stockListShort[5], -35, red, Stock.stockList[5]),
      PredectGrid(Stock.stockListShort[6], 40, green, Stock.stockList[6]),
    ];
    return data;
  }
}
