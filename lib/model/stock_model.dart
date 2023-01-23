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
  }) {

  }


  factory StockData.fromJson(List json) {
    var dateFormat = DateFormat("E, d MMM y H:m:s 'GMT'");
    var date = dateFormat.parse(json[1]);
    var openingPrice = json[2];
    var closingPrice = json[3];
    var lowP,highP;
    if ((closingPrice-openingPrice) > 0) {
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




List<StockData> getChartData() {
  return <StockData>[
    StockData(
        date: DateTime(2016, 01, 11),
        openingPrice: 98.97,
        highPrice: 101.19,
        lowPrice: 95.36,
        closingPrice: 97.13),
    StockData(
        date: DateTime(2016, 01, 18),
        openingPrice: 98.41,
        highPrice: 101.46,
        lowPrice: 93.42,
        closingPrice: 101.42),
    StockData(
        date: DateTime(2016, 01, 25),
        openingPrice: 101.52,
        highPrice: 101.53,
        lowPrice: 92.39,
        closingPrice: 97.34),
    StockData(
        date: DateTime(2016, 02, 01),
        openingPrice: 96.47,
        highPrice: 97.33,
        lowPrice: 93.69,
        closingPrice: 94.02),
    StockData(
        date: DateTime(2016, 02, 08),
        openingPrice: 93.13,
        highPrice: 96.35,
        lowPrice: 92.59,
        closingPrice: 93.99),
    StockData(
        date: DateTime(2016, 02, 15),
        openingPrice: 91.02,
        highPrice: 94.89,
        lowPrice: 90.61,
        closingPrice: 92.04),
    StockData(
        date: DateTime(2016, 02, 22),
        openingPrice: 96.31,
        highPrice: 98.0237,
        lowPrice: 98.0237,
        closingPrice: 96.31),
    StockData(
        date: DateTime(2016, 02, 29),
        openingPrice: 99.86,
        highPrice: 106.75,
        lowPrice: 99.65,
        closingPrice: 106.01),
    StockData(
        date: DateTime(2016, 03, 07),
        openingPrice: 102.39,
        highPrice: 102.83,
        lowPrice: 100.15,
        closingPrice: 102.26),
    StockData(
        date: DateTime(2016, 03, 14),
        openingPrice: 101.91,
        highPrice: 106.5,
        lowPrice: 101.78,
        closingPrice: 105.92),
    StockData(
        date: DateTime(2016, 03, 21),
        openingPrice: 105.93,
        highPrice: 107.65,
        lowPrice: 104.89,
        closingPrice: 105.67),
    StockData(
        date: DateTime(2016, 03, 28),
        openingPrice: 106,
        highPrice: 110.42,
        lowPrice: 104.88,
        closingPrice: 109.99),
    StockData(
        date: DateTime(2016, 04, 04),
        openingPrice: 110.42,
        highPrice: 112.19,
        lowPrice: 108.121,
        closingPrice: 108.66),
    StockData(
        date: DateTime(2016, 04, 11),
        openingPrice: 108.97,
        highPrice: 112.39,
        lowPrice: 108.66,
        closingPrice: 109.85),
    StockData(
        date: DateTime(2016, 04, 18),
        openingPrice: 108.89,
        highPrice: 108.95,
        lowPrice: 104.62,
        closingPrice: 105.68),
    StockData(
        date: DateTime(2016, 04, 25),
        openingPrice: 105,
        highPrice: 105.65,
        lowPrice: 92.51,
        closingPrice: 93.74),
    StockData(
        date: DateTime(2016, 05, 02),
        openingPrice: 93.965,
        highPrice: 95.9,
        lowPrice: 91.85,
        closingPrice: 92.72),
    StockData(
        date: DateTime(2016, 05, 09),
        openingPrice: 93,
        highPrice: 93.77,
        lowPrice: 89.47,
        closingPrice: 90.52),
    StockData(
        date: DateTime(2016, 05, 16),
        openingPrice: 92.39,
        highPrice: 95.43,
        lowPrice: 91.65,
        closingPrice: 95.22),
    StockData(
        date: DateTime(2016, 05, 23),
        openingPrice: 95.87,
        highPrice: 100.73,
        lowPrice: 95.67,
        closingPrice: 100.35),
    StockData(
        date: DateTime(2016, 05, 30),
        openingPrice: 99.6,
        highPrice: 100.4,
        lowPrice: 96.63,
        closingPrice: 97.92),
    StockData(
        date: DateTime(2016, 06, 06),
        openingPrice: 97.99,
        highPrice: 101.89,
        lowPrice: 97.55,
        closingPrice: 98.83),
    StockData(
        date: DateTime(2016, 06, 13),
        openingPrice: 98.69,
        highPrice: 99.12,
        lowPrice: 95.3,
        closingPrice: 95.33),
    StockData(
        date: DateTime(2016, 06, 20),
        openingPrice: 96,
        highPrice: 96.89,
        lowPrice: 92.65,
        closingPrice: 93.4),
    StockData(
        date: DateTime(2016, 06, 27),
        openingPrice: 93,
        highPrice: 96.465,
        lowPrice: 91.5,
        closingPrice: 95.89),
    StockData(
        date: DateTime(2016, 07, 04),
        openingPrice: 95.39,
        highPrice: 96.89,
        lowPrice: 94.37,
        closingPrice: 96.68),
    StockData(
        date: DateTime(2016, 07, 11),
        openingPrice: 96.75,
        highPrice: 99.3,
        lowPrice: 96.73,
        closingPrice: 98.78),
    StockData(
        date: DateTime(2016, 07, 18),
        openingPrice: 98.7,
        highPrice: 101,
        lowPrice: 98.31,
        closingPrice: 98.66),
    StockData(
        date: DateTime(2016, 07, 25),
        openingPrice: 98.25,
        highPrice: 104.55,
        lowPrice: 96.42,
        closingPrice: 104.21),
    StockData(
        date: DateTime(2016, 08, 01),
        openingPrice: 104.41,
        highPrice: 107.65,
        lowPrice: 104,
        closingPrice: 107.48),
    StockData(
        date: DateTime(2016, 08, 08),
        openingPrice: 107.52,
        highPrice: 108.94,
        lowPrice: 107.16,
        closingPrice: 108.18),
    StockData(
        date: DateTime(2016, 08, 15),
        openingPrice: 108.14,
        highPrice: 110.23,
        lowPrice: 108.08,
        closingPrice: 109.36),
    StockData(
        date: DateTime(2016, 08, 22),
        openingPrice: 108.86,
        highPrice: 109.32,
        lowPrice: 106.31,
        closingPrice: 106.94),
    StockData(
        date: DateTime(2016, 08, 29),
        openingPrice: 106.62,
        highPrice: 108,
        lowPrice: 105.5,
        closingPrice: 107.73),
    StockData(
        date: DateTime(2016, 09, 05),
        openingPrice: 107.9,
        highPrice: 108.76,
        lowPrice: 103.13,
        closingPrice: 103.13),
    StockData(
        date: DateTime(2016, 09, 12),
        openingPrice: 102.65,
        highPrice: 116.13,
        lowPrice: 102.53,
        closingPrice: 114.92),
    StockData(
        date: DateTime(2016, 09, 19),
        openingPrice: 115.19,
        highPrice: 116.18,
        lowPrice: 111.55,
        closingPrice: 112.71),
    StockData(
        date: DateTime(2016, 09, 26),
        openingPrice: 111.64,
        highPrice: 114.64,
        lowPrice: 111.55,
        closingPrice: 113.05),
    StockData(
        date: DateTime(2016, 10, 03),
        openingPrice: 112.71,
        highPrice: 114.56,
        lowPrice: 112.28,
        closingPrice: 114.06),
    StockData(
        date: DateTime(2016, 10, 10),
        openingPrice: 115.02,
        highPrice: 118.69,
        lowPrice: 114.72,
        closingPrice: 117.63),
    StockData(
        date: DateTime(2016, 10, 17),
        openingPrice: 117.33,
        highPrice: 118.21,
        lowPrice: 113.8,
        closingPrice: 116.6),
    StockData(
        date: DateTime(2016, 10, 24),
        openingPrice: 117.1,
        highPrice: 118.36,
        lowPrice: 113.31,
        closingPrice: 113.72),
    StockData(
        date: DateTime(2016, 10, 31),
        openingPrice: 113.65,
        highPrice: 114.23,
        lowPrice: 108.11,
        closingPrice: 108.84),
    StockData(
        date: DateTime(2016, 11, 07),
        openingPrice: 110.08,
        highPrice: 111.72,
        lowPrice: 105.83,
        closingPrice: 108.43),
    StockData(
        date: DateTime(2016, 11, 14),
        openingPrice: 107.71,
        highPrice: 110.54,
        lowPrice: 104.08,
        closingPrice: 110.06),
    StockData(
        date: DateTime(2016, 11, 21),
        openingPrice: 114.12,
        highPrice: 115.42,
        lowPrice: 115.42,
        closingPrice: 114.12),
    StockData(
        date: DateTime(2016, 11, 28),
        openingPrice: 111.43,
        highPrice: 112.465,
        lowPrice: 108.85,
        closingPrice: 109.9),
    StockData(
        date: DateTime(2016, 12, 05),
        openingPrice: 110,
        highPrice: 114.7,
        lowPrice: 108.25,
        closingPrice: 113.95),
    StockData(
        date: DateTime(2016, 12, 12),
        openingPrice: 113.29,
        highPrice: 116.73,
        lowPrice: 112.49,
        closingPrice: 115.97),
    StockData(
        date: DateTime(2016, 12, 19),
        openingPrice: 115.8,
        highPrice: 117.5,
        lowPrice: 115.59,
        closingPrice: 116.52),
    StockData(
        date: DateTime(2016, 12, 26),
        openingPrice: 116.52,
        highPrice: 118.0166,
        lowPrice: 115.43,
        closingPrice: 115.82),
  ];
}
