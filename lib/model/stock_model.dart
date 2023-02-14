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
    if(openingPrice == 0){
      openingPrice = closingPrice;
    }
    var lowP, highP;
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
}

class Stock {
  final String name;
  final String ticker;

  Stock(this.ticker, this.name);
}

List<Stock> stocks = [
  Stock('AAPL', 'Apple Inc.'),
  Stock('AMZN', 'Amazon.com Inc.'),
  Stock('GOOGL', 'Alphabet Inc.'),
  Stock('MSFT', 'Microsoft Corporation'),
  Stock('EBAY', 'Ebay Inc.'),
  Stock('ADBE', 'Adobe Inc.'),
  Stock('TSLA', 'Tesla Inc.'),
  // add more stocks as needed
];

