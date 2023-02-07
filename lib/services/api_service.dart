import 'dart:convert';

import 'package:flutter_application_2/model/gauge_model.dart';
import 'package:flutter_application_2/model/line_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/constants.dart';
import 'package:flutter_application_2/model/user_model.dart';

import '../model/stock_model.dart';

class ApiService {
  Future<List<UserModel>> getUsers() async {
    final response = await http
        .get(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<UserModel> model = userModelFromJson(response.body);
      return model;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Sentiment> getSentiment() async {
    final response = await http.get(Uri.parse(ApiConstants.gaugeUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Sentiment.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<LineData>> getLineData() async {
    final response = await http.get(Uri.parse(ApiConstants.lineChartUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<LineData> model = lineDataFromJson(response.body);

      return model;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<StockData>> fetchStockData(
      String stockCode, int? dayWeekMonth) async {
    /**the dayWeekMonth has values
         *  null => retrun data as sent from the api
         *  0    => retrun daily data
         *  1    => retrun weekly data
         *  2    => retrun monthly data
         * for now null and 0 have the same effect
         */
    //TODO : remove this dummy-data part
    if (stockCode == 'TESTf') {
      List<StockData> stockDataList = [];
      double myConstAux;
      if (dayWeekMonth == null || dayWeekMonth == 0) {
        myConstAux = 0;
      } else if (dayWeekMonth == 1) {
        myConstAux = 7;
      } else {
        myConstAux = 3;
      }
      for (var i = 0; i < 15; i++) {
        double open = 10 + i * 5 + myConstAux;
        double close = 8 + i * 3;
        double low = 5 + i * 4;
        double high = 12 + i * 6;
        stockDataList.add(StockData(
            date: DateTime.fromMicrosecondsSinceEpoch(1 + i * 2850000000000),
            openingPrice: open,
            closingPrice: close,
            lowPrice: low,
            highPrice: high));
      }
      return stockDataList;
    }
    //TODO: implement a func to get daily,weekly and monthly from the data fetched from the API
    final response = await http.get(
      Uri.parse("${ApiConstants.candleUrl}/$stockCode"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
      },
    );
    if (response.statusCode == 200) {
      // If the call to the API was successful, parse the JSON
      String modifiedJsonString = response.body.replaceAll("NaN", "0.0");
      var data = jsonDecode(modifiedJsonString);
      var predictionset = data["predictionset"];
      List<StockData> stockDataList = [];
      for (var i in predictionset) {
        stockDataList.add(StockData.fromJson(i));
      }
      return stockDataList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load stock data');
    }
  }
}
