import 'dart:convert';

import 'package:flutter_application_2/model/gauge_model.dart';
import 'package:flutter_application_2/model/line_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/constants.dart';
import 'package:flutter_application_2/model/user_model.dart';

import '../model/main_model.dart';
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

  Future<List<StockData>> fetchStockData(String stockCode) async {
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

  Future<List<StockData>> fetchStockDataTimed(String stockCode, DateTime startDate, DateTime endDate) async {
    String start =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    String end =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
    final response = await http.get(
      Uri.parse("${ApiConstants.candleUrl}/$stockCode/start=$start&end=$end"),
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

  Future<List<StockData>> fetchStockDataToday(String stockCode) async {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    String end =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String start =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
    final response = await http.get(
      Uri.parse("${ApiConstants.candleUrl}/$stockCode/start=$start&end=$end"),
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

  Future<Map<String, MainModel>> fetchMainData() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.mainUrl}/api/stocks/"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
      },
    );

    if (response.statusCode == 200) {
      // If the call to the API was successful, parse the JSON.
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final mainData = data.map((key, value) {
        final mainModel = MainModel.fromJson(value);
        return MapEntry(key, mainModel);
      });

      MainModel.data = mainData; // Set the mainData using the static setter

      return mainData;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load stock data from API');
    }
  }


}
