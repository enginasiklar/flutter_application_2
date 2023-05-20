import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/services/api_service.dart';

class PredictionsData {
  /* in stocksData map variable, stocks and their data are stored
  data can be fetched just once and saved temp. in this variable
   */
  static Map<String, List<StockData>> stocksData = {};

  // returns stockData using only the code
  static Future<List<StockData>> getStockData(String stockCode) async {
    if (!stocksData.containsKey(stockCode)) {
      stocksData[stockCode] = await ApiService().fetchStockData(stockCode);
      return stocksData[stocksData]!.toList();
    }
    return stocksData[stockCode]!.toList();
  }

// force update data for a certain stock
  static forceRefreshData(String stockCode) async {
    stocksData[stockCode] = await ApiService().fetchStockData(stockCode);
  }

  // returns stockData using code and dates
  static Future<List<StockData>> getStockDataDates(String stockCode, DateTime startDate, DateTime endDate) async {
    if (stocksData.containsKey(stockCode)) {
      // sould be negative if the startDate already exists
      int startDiff =
          stocksData[stockCode]!.first.date.difference(startDate).inDays;
      // sould be positive if the endDate already exists
      int endDiff = stocksData[stockCode]!.last.date.difference(endDate).inDays;
      // case 1 all data is present
      if (startDiff <= 0 && endDiff >= 0) {
        int startIndex = stocksData[stockCode]!
            .indexWhere((element) => element.date == startDate);
        int endIndex = stocksData[stockCode]!
            .indexWhere((element) => element.date == endDate);
        return stocksData[stockCode]!.sublist(startIndex, endIndex);
      }
      // case 2 not all data present
      else {
        await _addStockDataDates(stockCode, startDate, endDate);
        int startIndex = stocksData[stockCode]!
            .indexWhere((element) => element.date == startDate);
        int endIndex = stocksData[stockCode]!
            .indexWhere((element) => element.date == endDate);
        //TODO: find a better way to set the data if index does not fit
        if (startIndex > 0 && endIndex < stocksData[stockCode]!.length && endIndex > 0 && startIndex < stocksData[stockCode]!.length) {
          return stocksData[stockCode]!.sublist(startIndex, endIndex);
        }
        return stocksData[stockCode]!.toList();
      }
    }
    // case stock not present
    else {
      await _addStockDataDates(stockCode, startDate, endDate);
      int startIndex = stocksData[stockCode]!
          .indexWhere((element) => element.date == startDate);
      int endIndex = stocksData[stockCode]!
          .indexWhere((element) => element.date == endDate);
      return stocksData[stockCode]!.sublist(startIndex, endIndex);
    }
  }

// private function to add stockData to a stock using dates
  static _addStockDataDates(String stockCode, DateTime startDate, DateTime endDate) async {
    if (stocksData.containsKey(stockCode)) {
      // sould be negative if the startDate already exists
      int startDiff =
          stocksData[stockCode]!.first.date.difference(startDate).inDays;
      // sould be positive if the endDate already exists
      int endDiff = stocksData[stockCode]!.last.date.difference(endDate).inDays;
      // case 1 all data is present
      if (startDiff < 0 && endDiff > 0) {
        // add no data
      }
      // case 2 some start data not present
      else if (startDiff > 0 && endDiff > 0) {
        // add head data
        DateTime endDateAux = startDate.add(Duration(days: startDiff - 1));
        await ApiService()
            .fetchStockDataTimed(stockCode, startDate, endDateAux)
            .then((value) {
          stocksData[stockCode]!.insertAll(0, value);
        });
      }
      // case 3 some start and end data not present
      else if (startDiff > 0 && endDiff < 0) {
        // add tail data
        int indexAux = stocksData[stockCode]!.length;
        DateTime startDateAux1 = endDate.subtract(Duration(days: endDiff - 1));
        await ApiService()
            .fetchStockDataTimed(stockCode, startDateAux1, endDate)
            .then((value) {
          stocksData[stockCode]!.insertAll(indexAux, value);
        });
        // add head data
        DateTime endDateAux1 = startDate.add(Duration(days: startDiff - 1));
        await ApiService()
            .fetchStockDataTimed(stockCode, startDate, endDateAux1)
            .then((value) {
          stocksData[stockCode]!.insertAll(0, value);
        });
      }
      // case 4 some end data not present
      else {
        // add tail data
        int indexAux = stocksData[stockCode]!.length;
        DateTime startDateAux1 = endDate.subtract(Duration(days: endDiff - 1));
        await ApiService()
            .fetchStockDataTimed(stockCode, startDateAux1, endDate)
            .then((value) {
          stocksData[stockCode]!.insertAll(indexAux, value);
        });
      }
    } else {
      stocksData[stockCode] =
          await ApiService().fetchStockDataTimed(stockCode, startDate, endDate);
    }
  }

  static Widget getChangeLastMonth(String stockCode, bool setTextStyle) {
    DateTime lastMonth = DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
    DateTime yesterday = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    return FutureBuilder<List<StockData>>(
      future: getStockDataDates(stockCode, lastMonth, yesterday),
      builder: (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
        if (snapshot.hasData) {
          // Get the most recent closing price from the fetched data
          double yesterdayPrice = snapshot.data!.last.closingPrice;
          double lastMonthPrice = snapshot.data!.first.closingPrice;
          double percentageChange =
              (yesterdayPrice - lastMonthPrice) * 100 / lastMonthPrice;
          if (setTextStyle) {
            return Text(
              'Change from Last Month: ${percentageChange.toStringAsFixed(2)}%',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: percentageChange > 0 ? Colors.green : Colors.red),
            );
          }
          return Text(
            '${percentageChange.toStringAsFixed(2)}%',
          );
        } else if (snapshot.hasError) {
          return const Text("data not found");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  static Widget getMonthlyChangeAvg(String stockCode, bool setTextStyle) {
    DateTime lastMonth = DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
    DateTime yesterday = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    return FutureBuilder<List<StockData>>(
      future: getStockDataDates(stockCode, lastMonth, yesterday),
      builder: (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
        if (snapshot.hasData) {
          double sumPercentageChange = 0;
          for (int i = 0; i < snapshot.data!.length; i++) {
            double percentageChange = (snapshot.data![i].closingPrice - snapshot.data![i].openingPrice).abs() * 100 / snapshot.data![i].openingPrice;
            sumPercentageChange += percentageChange;
          }
          double avgPercentageChange = sumPercentageChange / snapshot.data!.length;

          if (setTextStyle) {
            return Text(
              'Monthly Average Prediction Difference: ${avgPercentageChange.toStringAsFixed(2)}%',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: avgPercentageChange > 2 ? Colors.red : Colors.green),
            );
          }
          return Text(
            '${avgPercentageChange.toStringAsFixed(2)}%',
          );
        } else if (snapshot.hasError) {
          return const Text("data not found");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  static Widget getPredictedPrice(String stockCode) {
    late Future<List<StockData>> predictedPrice;
    DateTime now = DateTime.now()
    /*.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    )*/;
    DateTime yesterday = now.subtract(const Duration(days: 1));
    predictedPrice = getStockDataDates(stockCode, yesterday, now);
    return Expanded(
      child: FutureBuilder<List<StockData>>(
        future: predictedPrice,
        builder:
            (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
          if (snapshot.hasData) {
            // Get the most recent closing price from the fetched data
            double closingPrice = snapshot.data!.last.closingPrice;
            // Update the mostRecentPrice variable
            var mostRecentPrice = closingPrice.toStringAsFixed(2);
            return Text(
              'Predicted Price: $mostRecentPrice',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  static Future<String> getChangedValue(String stockCode) async {
    DateTime lastMonth = DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
    DateTime yesterday = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    try {
      List<StockData> data =
          await getStockDataDates(stockCode, lastMonth, yesterday);
      if (data.isNotEmpty) {
        // Get the most recent closing price from the fetched data
        double yesterdayPrice = data.last.closingPrice;
        double lastMonthPrice = data.first.closingPrice;
        double percentageChange =
            (yesterdayPrice - lastMonthPrice) * 100 / lastMonthPrice;
        return percentageChange.toStringAsFixed(2);
      } else {
        return "#";
      }
    } catch (e) {
      return "#";
    }
  }

  static Widget getCompAbs(String stockCode) {
    late Future<List<StockData>> predictedPrice;
    predictedPrice = ApiService().fetchStockDataToday(stockCode);
    return Expanded(
      child: FutureBuilder<List<StockData>>(
        future: predictedPrice,
        builder:
            (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
          if (snapshot.hasData) {
            // Get the most recent closing price from the fetched data
            double predictedPrice = snapshot.data!.last.closingPrice;
            double realPrice = snapshot.data!.last.closingPrice;
            // Update the mostRecentPrice variable
            var difference = predictedPrice - realPrice;
            var percentageChange = (difference * 100) / realPrice;
            return Row(
              children: [
                Text(
                  'Abs Difference: $difference',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(
                  'Percentage Difference: ${percentageChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: percentageChange > 0 ? Colors.green : Colors.red),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
