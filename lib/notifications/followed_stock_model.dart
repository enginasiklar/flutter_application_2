import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/main_model.dart';

class FollowedStocksModel extends ChangeNotifier {


  Future<List<MainModel>> getNotificationStocks() async {
    return [];
  }


  void addNotification(String stockCode) {

  }

  void removeNotification(String stockCode) {

  }

  /// Removes all items from the cart.



  void updateLimitValue(String stockCode, double newValue) {

  }

}
