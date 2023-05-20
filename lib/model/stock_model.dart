import 'package:intl/intl.dart';

import 'main_model.dart';
import 'package:intl/intl.dart';

class StockData {
  final DateTime date;
  final double openingPrice;
  final double closingPrice;
  late double lowPrice;
  late double highPrice;


  StockData({
    required this.date,
    required this.openingPrice,
    required this.closingPrice,
    required this.lowPrice,
    required this.highPrice,
  });

  factory StockData.fromJson(List json) {
    var dateFormat = DateFormat("E, d MMM y H:m:s 'GMT'");
    var date = dateFormat.parse(json[1]);
    var openingPrice = json[2];
    var closingPrice = json[3];
    if (openingPrice == 0) {
      openingPrice = closingPrice;
    }
    double lowP, highP;
    if ((closingPrice - openingPrice) > 0) {
      lowP = openingPrice;
      highP = closingPrice;
    } else {
      lowP = closingPrice;
      highP = openingPrice;
    }

    return StockData(
      date: DateTime(date.year, date.month, date.day),
      openingPrice: openingPrice,
      closingPrice: closingPrice,
      lowPrice: lowP,
      highPrice: highP,
    );
  }

  static List<StockData> getWeekly(List<StockData> daily) {
    //TODO: better algorithm
    List<StockData> myList = [];
    int loops = daily.length ~/ 7;
    for (int i = 0; i < loops; i++) {
      double close = 0;
      double open = 0;
      double low = 0;
      double high = 0;
      for (var j = 0; j < 7; j++) {
        close += daily[i * 7 + j].closingPrice;
        open += daily[i * 7 + j].openingPrice;
        low += daily[i * 7 + j].lowPrice;
        high += daily[i * 7 + j].highPrice;
      }
      close /= 7;
      open /= 7;
      low /= 7;
      high /= 7;
      myList.add(StockData(
          date: daily[i * 7].date,
          openingPrice: open,
          closingPrice: close,
          lowPrice: low,
          highPrice: high));
    }
    if (daily.length % 7 != 0) {
      double close = 0;
      double open = 0;
      double low = 0;
      double high = 0;
      for (int i = loops * 7; i < daily.length; i++) {
        close += daily[i].closingPrice;
        open += daily[i].openingPrice;
        low += daily[i].lowPrice;
        high += daily[i].highPrice;
      }
      close /= daily.length - loops * 7;
      open /= daily.length - loops * 7;
      low /= daily.length - loops * 7;
      high /= daily.length - loops * 7;
      myList.add(StockData(
          date: daily[loops * 7].date,
          openingPrice: open,
          closingPrice: close,
          lowPrice: low,
          highPrice: high));
    }
    return myList;
  }

  static List<StockData> getMonthly(List<StockData> weekly) {
    //TODO: better algorithm
    List<StockData> myList = [];
    int loops = weekly.length ~/ 4;
    for (int i = 0; i < loops; i++) {
      double close = 0;
      double open = 0;
      double low = 0;
      double high = 0;
      for (var j = 0; j < 4; j++) {
        close += weekly[i * 4 + j].closingPrice;
        open += weekly[i * 4 + j].openingPrice;
        low += weekly[i * 4 + j].lowPrice;
        high += weekly[i * 4 + j].highPrice;
      }
      close /= 4;
      open /= 4;
      low /= 4;
      high /= 4;
      myList.add(StockData(
          date: weekly[i * 4].date,
          openingPrice: open,
          closingPrice: close,
          lowPrice: low,
          highPrice: high));
    }
    if (weekly.length % 4 != 0) {
      double close = 0;
      double open = 0;
      double low = 0;
      double high = 0;
      for (int i = loops * 4; i < weekly.length; i++) {
        close += weekly[i].closingPrice;
        open += weekly[i].openingPrice;
        low += weekly[i].lowPrice;
        high += weekly[i].highPrice;
      }
      close /= weekly.length - loops * 4;
      open /= weekly.length - loops * 4;
      low /= weekly.length - loops * 4;
      high /= weekly.length - loops * 4;
      myList.add(StockData(
          date: weekly[loops * 4].date,
          openingPrice: open,
          closingPrice: close,
          lowPrice: low,
          highPrice: high));
    }
    return myList;
  }
}

class Stock {
  final String name;
  final String ticker;

  Stock(this.ticker, this.name);

  static List<Stock> stockListFromMainData(Map<String, MainModel> mainData) {
    List<Stock> stocks = [];
    mainData.forEach((key, value) {
      stocks.add(Stock(key, value.name));
    });
    return stocks;
  }

  static List<Stock> stockList = Stock.stockListFromMainData(MainModel.data);
  static List<String> stockListShort = stockList.map((stock) => stock.name).toList();
}

