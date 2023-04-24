import 'dart:math';

import '../model/stock_model.dart';

class FollowedStockItem {
  String stockCode;
  String stockName;
  double? limitValue = 1;
  FollowedStockItem(this.stockCode, this.stockName, this.limitValue);
  static List<FollowedStockItem> getNotifications() {
    List<FollowedStockItem> notif = [];
    for (Stock element in Stock.stockList) {
      notif.add(FollowedStockItem(element.ticker, element.name,
          ((Random().nextDouble() * 10 - 5) * 100).roundToDouble() / 100));
    }
    return notif;
  }
}
