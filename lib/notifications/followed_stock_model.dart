import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/notifications/followed_stock_item.dart';

class FollowedStocksModel extends ChangeNotifier {
  //TODO: the data has to be saved permanetelly somehow
  static final List<FollowedStockItem> _notifications = [];
  UnmodifiableListView<FollowedStockItem> get items =>
      UnmodifiableListView(_notifications);

  void add(FollowedStockItem notifications) {
    if (_notifications.indexWhere(
            (element) => element.stockCode == notifications.stockCode) ==
        -1) {
      _notifications.add(notifications);
      notifyListeners();
    }
    // This call tells the widgets that are listening to this model to rebuild.
  }

  void remove(String stockCode) {
    _notifications.removeWhere((element) => element.stockCode == stockCode);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _notifications.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool doesExist(String stockCode) {
    if (_notifications
            .indexWhere((element) => element.stockCode == stockCode) ==
        -1) {
      return false;
    }
    return true;
  }

  void updateLimitValue(String stockCode, double newValue) {
    _notifications
        .where((element) => element.stockCode == stockCode)
        .first
        .limitValue = newValue;
  }

  void alterExistance(FollowedStockItem notifications) {
    if (doesExist(notifications.stockCode)) {
      remove(notifications.stockCode);
    } else {
      add(notifications);
    }
    notifyListeners();
  }
}
