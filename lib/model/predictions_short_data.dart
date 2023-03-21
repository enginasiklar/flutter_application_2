import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/services/api_service.dart';

class PredictionsShortData {
  static Widget getChangeLastMonth(String stockCode, bool setTextStyle) {
    DateTime lastMonth = DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
    DateTime yesterday = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    return FutureBuilder<List<StockData>>(
      future: ApiService().fetchStockDataTimed(stockCode, lastMonth, yesterday),
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

  static Widget getPredictedPrice(String stockCode) {
    late Future<List<StockData>> predictedPrice;
    predictedPrice = ApiService().fetchStockDataToday(stockCode);
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
      List<StockData> data = await ApiService()
          .fetchStockDataTimed(stockCode, lastMonth, yesterday);
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
