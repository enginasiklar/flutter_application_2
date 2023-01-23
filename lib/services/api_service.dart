import 'dart:convert';

import 'package:flutter_application_2/charts/line_chart.dart';
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
    final response = await http
        .get(Uri.parse(ApiConstants.gaugeUrl));

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
    final response = await http
        .get(Uri.parse(ApiConstants.lineChartUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<LineData> model = LineDataFromJson(response.body);

      return model;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<StockData>> fetchStockData(String stockCode) async {
    if (stockCode == 'PRDC') {
      return getChartData();
    }
    final response = await http.get(
      Uri.parse(ApiConstants.candleUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
      },
    );
    if (response.statusCode == 200) {
      // If the call to the API was successful, parse the JSON
      var data = jsonDecode(response.body);
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


