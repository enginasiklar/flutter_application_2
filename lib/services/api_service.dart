import 'dart:convert';
import 'package:flutter_application_2/model/gauge_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/constants.dart';
import '../model/main_model.dart';
import '../model/stock_model.dart';

class ApiService { Future<Sentiment> getSentiment() async {final response = await http.get(Uri.parse(ApiConstants.gaugeUrl));
    if (response.statusCode == 200) {return Sentiment.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to load album');}}
  Future<List<StockData>> fetchStockData(String stockCode) async {
    try {final response = await http.get(Uri.parse("${ApiConstants.candleUrl}/$stockCode"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}',},);
      if (response.statusCode == 200) {String modifiedJsonString = response.body.replaceAll("NaN", "0.0");
        var data = jsonDecode(modifiedJsonString); var predictionset = data["predictionset"];
        List<StockData> stockDataList = []; for (var i in predictionset) {StockData stockData = StockData.fromJson(i);stockDataList.add(stockData);}
      return stockDataList;} else {throw Exception('Failed to load stock data');}} catch (error) {throw Exception('Error: $error');}}

  Future<List<StockData>> fetchStockDataTimed(String stockCode, DateTime startDate, DateTime endDate) async {
    String start =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    String end =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
    final response = await http.get(
      Uri.parse("${ApiConstants.candleUrl}/$stockCode/start=$start&end=$end"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}',},);
    if (response.statusCode == 200) {String modifiedJsonString = response.body.replaceAll("NaN", "0.0"); var data = jsonDecode(modifiedJsonString); var predictionset = data["predictionset"];
      List<StockData> stockDataList = []; for (var i in predictionset) {stockDataList.add(StockData.fromJson(i));}return stockDataList;} else {throw Exception('Failed to load stock data');}}

  Future<List<StockData>> fetchStockDataToday(String stockCode) async {DateTime now = DateTime.now(); DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    String end = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String start = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
    final response = await http.get(Uri.parse("${ApiConstants.candleUrl}/$stockCode/start=$start&end=$end"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}',},);
    if (response.statusCode == 200) { String modifiedJsonString = response.body.replaceAll("NaN", "0.0");var data = jsonDecode(modifiedJsonString); var predictionset = data["predictionset"];
      List<StockData> stockDataList = []; for (var i in predictionset) {stockDataList.add(StockData.fromJson(i));}return stockDataList;} else {throw Exception('Failed to load stock data');}}

  Future<Map<String, MainModel>> fetchMainData() async { final response = await http.get(
      Uri.parse("${ApiConstants.mainUrl}/api/stocks/"), headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}',},);
  if (response.statusCode == 200) {final data = jsonDecode(response.body) as Map<String, dynamic>;final mainData = data.map((key, value) {final mainModel = MainModel.fromJson(value);
        return MapEntry(key, mainModel);});
    MainModel.data = mainData;return mainData;} else {throw Exception('Failed to load stock data from API');}}

  static void sendNotificationData(String? userID, String selectedButton, String stockName) async {
    final Map<String, String> requestData = {"userID": userID!, "percentage": selectedButton, "tickerID": stockName,};
    final response = await http.post(Uri.parse("${ApiConstants.mainUrl}/api/users/stock/notifications/"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}', 'Content-Type': 'application/json',}, body: jsonEncode(requestData),);
    if (response.statusCode != 200) {throw Exception('Failed to send notification data');}}

  static void sendUserData(String? userID, String? fcmToken) async {final Map<String, String> requestData = {"userID": userID!, "fcmToken": fcmToken!,};
  final response = await http.post(Uri.parse("${ApiConstants.mainUrl}/api/users/stock/notifications/"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}', 'Content-Type': 'application/json',}, body: jsonEncode(requestData),);
  if (response.statusCode != 200) {throw Exception('Failed to send user data');}}

  static Future<void> deleteNotification(String? userID, String stockCode, String percentage) async {
    final Map<String, String> requestData = {
      "userID": userID!,
      "stockCode": stockCode,
      "percentage": percentage,
    };

    final response = await http.delete(Uri.parse("${ApiConstants.mainUrl}/api/users/stock/notifications/"),
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode(ApiConstants.authorization))}', 'Content-Type': 'application/json',},
      body: jsonEncode(requestData),); if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');}}









}
