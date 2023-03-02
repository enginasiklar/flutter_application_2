import 'package:flutter_application_2/model/stock_model.dart';

class SearchModel {
  static List<Stock> getListFromQuery(String query) {
    return Stock.stockList
        .where((element) =>
            element.ticker.contains(RegExp(query, caseSensitive: false)) ||
            element.name.contains(RegExp(query, caseSensitive: false)))
        .toList();
  }
}
