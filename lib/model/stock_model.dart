import 'package:intl/intl.dart';
import 'main_model.dart';

class StockData {
  final DateTime date;
  final double openingPrice;
  final double closingPrice;
  final double predictedPrice;

  StockData({
    required this.date,
    required this.openingPrice,
    required this.closingPrice,
    required this.predictedPrice,
  });

  factory StockData.fromJson(List json) {
    var dateFormat = DateFormat("E, d MMM y H:m:s 'GMT'");
    var date = dateFormat.parse(json[1]);
    var openingPrice = json[2];
    var closingPrice = json[3];
    var predictedPrice = json[4];
    if (openingPrice == 0) {
      openingPrice = closingPrice;
    }

    return StockData(
      date: DateTime(date.year, date.month, date.day),
      openingPrice: openingPrice,
      closingPrice: closingPrice,
      predictedPrice: predictedPrice,
    );
  }

  static List<StockData> getWeekly(List<StockData> daily) {
    List<StockData> myList = [];
    int loops = daily.length ~/ 7;
    for (int i = 0; i < loops; i++) {
      double close = 0;
      double open = 0;
      double predictedValue = 0;

      for (var j = 0; j < 7; j++) {
        close += daily[i * 7 + j].closingPrice;
        open += daily[i * 7 + j].openingPrice;
        predictedValue += daily[i * 7 + j].predictedPrice;
      }

      close /= 7;
      open /= 7;
      predictedValue /= 7;

      myList.add(StockData(
        date: daily[i * 7].date,
        openingPrice: open,
        closingPrice: close,
        predictedPrice: predictedValue,
      ));
    }

    if (daily.length % 7 != 0) {
      double close = 0;
      double open = 0;
      double predictedValue = 0;

      for (int i = loops * 7; i < daily.length; i++) {
        close += daily[i].closingPrice;
        open += daily[i].openingPrice;
        predictedValue += daily[i].predictedPrice ?? 0;
      }

      close /= daily.length - loops * 7;
      open /= daily.length - loops * 7;
      predictedValue /= daily.length - loops * 7;

      myList.add(StockData(
        date: daily[loops * 7].date,
        openingPrice: open,
        closingPrice: close,
        predictedPrice: predictedValue,
      ));
    }
    return myList;
  }

  static List<StockData> getMonthly(List<StockData> weekly) {
    List<StockData> myList = [];
    int loops = weekly.length ~/ 4;
    for (int i = 0; i < loops; i++) {
      double close = 0;
      double open = 0;
      double predictedValue = 0;

      for (var j = 0; j < 4; j++) {
        close += weekly[i * 4 + j].closingPrice;
        open += weekly[i * 4 + j].openingPrice;

        predictedValue += weekly[i * 4 + j].predictedPrice ?? 0;
      }

      close /= 4;
      open /= 4;
      predictedValue /= 4;

      myList.add(StockData(
        date: weekly[i * 4].date,
        openingPrice: open,
        closingPrice: close,
        predictedPrice: predictedValue,
      ));
    }

    if (weekly.length % 4 != 0) {
      double close = 0;
      double open = 0;
      double predictedValue = 0;

      for (int i = loops * 4; i < weekly.length; i++) {
        close += weekly[i].closingPrice;
        open += weekly[i].openingPrice;
        predictedValue += weekly[i].predictedPrice ?? 0;
      }

      close /= weekly.length - loops * 4;
      open /= weekly.length - loops * 4;
      predictedValue /= weekly.length - loops * 4;

      myList.add(StockData(
        date: weekly[loops * 4].date,
        openingPrice: open,
        closingPrice: close,
        predictedPrice: predictedValue,
      ));
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
  static List<String> stockListShort =
      stockList.map((stock) => stock.name).toList();
}
