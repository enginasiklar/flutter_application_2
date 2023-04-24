import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/notifications/followed_stock_model.dart';
import 'package:provider/provider.dart';
import '../pages/stock_page.dart';
import 'followed_stock_item.dart';
import 'following_setting_view.dart';

class FollowedStocksListView extends StatefulWidget {
  FollowedStocksListView({super.key});

  @override
  State<FollowedStocksListView> createState() => _FollowedStocksListViewState();
}

class _FollowedStocksListViewState extends State<FollowedStocksListView> {
  // List<NotificationItem> notifications = NotificationItem.getNotifications();

  @override
  Widget build(BuildContext context) {
    UnmodifiableListView<FollowedStockItem> notificationModel =
        FollowedStocksModel().items;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            // toolbarHeight: 0,
            title: const Text("Notifications"),
            actions: [
              IconButton(
                  onPressed: () {
                    Provider.of<FollowedStocksModel>(context, listen: false)
                        .removeAll();
                  },
                  icon: const Icon(Icons.delete_forever_rounded))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.notifications),
                  child: Text("Notifications"),
                ),
                Tab(
                  icon: Icon(Icons.bar_chart_rounded),
                  child: Text("Followed"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //TODO: this child has to be changed to the real notifications
              Consumer<FollowedStocksModel>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: notificationModel.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        //TODO
                        leading: Random().nextBool()
                            ? Image.asset(
                                "assets/images/arrow_down.png",
                                height: 20,
                              )
                            : Image.asset(
                                "assets/images/arrow_up.png",
                                height: 20,
                              ),
                        title: Text(notificationModel[index].stockCode),
                        subtitle: Text(notificationModel[index].stockName),
                        //TODO: add insted of limitValue, the real data of today
                        trailing:
                            Text("${notificationModel[index].limitValue}"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            // return const stockPage();
                            return StockPage(
                              stockCode: notificationModel[index].stockCode,
                              stockName: notificationModel[index].stockName,
                            );
                          }));
                        },
                        onLongPress: () {
                          Provider.of<FollowedStocksModel>(context,
                                  listen: false)
                              .remove(notificationModel[index].stockCode);
                        },
                      );
                    },
                  );
                },
              ),
              Consumer<FollowedStocksModel>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: notificationModel.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        //TODO
                        leading: Random().nextBool()
                            ? Image.asset(
                                "assets/images/arrow_down.png",
                                height: 20,
                              )
                            : Image.asset(
                                "assets/images/arrow_up.png",
                                height: 20,
                              ),
                        title: Text(notificationModel[index].stockCode),
                        subtitle: Text(notificationModel[index].stockName),
                        trailing: IconButton(
                            onPressed: () {
                              FollowingSettingView.showAlertDialog(
                                  context,
                                  notificationModel[index].stockName,
                                  notificationModel[index].stockCode);
                            },
                            icon: Icon(Icons.settings)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            // return const stockPage();
                            return StockPage(
                              stockCode: notificationModel[index].stockCode,
                              stockName: notificationModel[index].stockName,
                            );
                          }));
                        },
                        onLongPress: () {
                          Provider.of<FollowedStocksModel>(context,
                                  listen: false)
                              .remove(notificationModel[index].stockCode);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}
