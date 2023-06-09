import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../model/main_model.dart';
import '../pages/stock_page.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

//TODO: add italian
Future<void> deleteAllFavorites() async {
  final user = FirebaseAuth.instance.currentUser;
  final userID = user?.uid;
  var db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection("favorites").where("userID", isEqualTo: userID).get();
  for (final doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

class FollowedStocksListView extends StatefulWidget {
  const FollowedStocksListView({Key? key}) : super(key: key);
  @override
  State<FollowedStocksListView> createState() => _FollowedStocksListViewState();
}

class _FollowedStocksListViewState extends State<FollowedStocksListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentTabIndex;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentTabIndex = 0;
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  void _handleTrashButton() {
    if (_currentTabIndex == 0) {
      //DeleteAllNotifications(); // Call the function to delete all notifications
    } else if (_currentTabIndex == 1) {
      deleteAllFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            onPressed: _handleTrashButton,
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.notifications),
              child: Text("Notifications"),
            ),
            Tab(
              icon: Icon(Icons.bar_chart_rounded),
              child: Text("Favorites"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NotificationsPage(),
          FavoritesPage(),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<MainModel>> getFavoriteStocks() async {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    if (userID != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userID', isEqualTo: userID)
          .get();
      final favorites = snapshot.docs.map((doc) => doc['tickerID']).toList();
      final mainData = MainModel.data;
      final favoriteStocks = mainData.values
          .where((stock) => favorites.contains(stock.name))
          .toList();
      return favoriteStocks;
    }
    return [];
  }

  Future<void> toggleFavorite(String stockCode) async {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    var db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("favorites")
        .where("userID", isEqualTo: userID)
        .where("tickerID", isEqualTo: stockCode)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<MainModel>>(
        future: getFavoriteStocks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final favoriteStocks = snapshot.data;
            return ListView.builder(
              itemCount: favoriteStocks?.length,
              itemBuilder: (context, index) {
                final favoriteStock = favoriteStocks![index];
                return ListTile(
                  leading: (favoriteStock.todayValue -
                              favoriteStock.yesterdayValue) >
                          0
                      ? Image.asset("assets/images/arrow_up.png", height: 20)
                      : Image.asset("assets/images/arrow_down.png", height: 20),
                  title: Text(favoriteStock.name),
                  subtitle: Text(favoriteStock.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await toggleFavorite(favoriteStock.name);
                          setState(() {});
                        },
                        icon: const Icon(Icons.favorite),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ClockPopupPage(stockName: favoriteStock.name),
                          );
                        },
                        icon: const Icon(Icons.access_time),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => StockPage(
                        stockCode: favoriteStock.name,
                        stockName: favoriteStock.name,
                      ),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ClockPopupPage extends StatefulWidget {
  final String stockName;
  const ClockPopupPage({Key? key, required this.stockName}) : super(key: key);
  @override
  _ClockPopupPageState createState() => _ClockPopupPageState();
}

class _ClockPopupPageState extends State<ClockPopupPage> {
  late String selectedButton;
  @override
  void initState() {
    super.initState();
    selectedButton = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.stockName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('0.5%'),
            value: '0.5',
            groupValue: selectedButton,
            onChanged: (value) {
              setState(() {
                selectedButton = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('1.0%'),
            value: '1.0',
            groupValue: selectedButton,
            onChanged: (value) {
              setState(() {
                selectedButton = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('1.5%'),
            value: '1.5',
            groupValue: selectedButton,
            onChanged: (value) {
              setState(() {
                selectedButton = value.toString();
              });
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            createNotification(context, selectedButton, widget.stockName);
          },
          child: const Text('Create Notification'),
        ),
      ],
    );
  }
}

void createNotification(
    BuildContext context, String selectedButton, String stockName) async {
  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken = await messaging.getToken();
  final notificationSnapshot = await db
      .collection("notifications")
      .where("userID", isEqualTo: userID)
      .get();
  final notificationCount = notificationSnapshot.docs.length;
  const int maxNotifications = 5; // Set your desired maximum notification count
  if (notificationCount >= maxNotifications) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification Limit Exceeded"),
          content: const Text(
              "You have reached the maximum number of notifications."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    return;
  }
  ApiService.sendUserData(userID, fcmToken);
  ApiService.sendNotificationData(userID, selectedButton, stockName);
  Navigator.of(context).pop();
}

Future<void> deleteNotification(String stockCode) async {
  final user = FirebaseAuth.instance.currentUser;
  final userID = user?.uid;
  var db = FirebaseFirestore.instance;
  final snapshot = await db
      .collection("notifications")
      .where("userID", isEqualTo: userID)
      .where("tickerID", isEqualTo: stockCode)
      .get();
  if (snapshot.docs.isNotEmpty) {
    final percentage = snapshot.docs.first['percentage'];
    await ApiService.deleteNotification(userID, stockCode, percentage);
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<List<Map<String, dynamic>>> getNotificationStocks() async {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;
    if (userID != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userID', isEqualTo: userID)
          .get();
      final notificationStocks = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['tickerID'],
          'percentage': data['percentage'],
        };
      }).toList();
      return notificationStocks;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNotificationStocks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final notificationStocks = snapshot.data;
            final int remainingNotifications =
                5 - (notificationStocks?.length ?? 0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Add space at the top
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "You have $remainingNotifications unique notifications left",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(), // Add a separating line
                Expanded(
                  child: ListView.builder(
                    itemCount: notificationStocks?.length,
                    itemBuilder: (context, index) {
                      final notificationStock = notificationStocks![index];
                      final stockName = notificationStock['name'];
                      final percentage = notificationStock['percentage'];
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              stockName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$percentage%",
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await deleteNotification(stockName);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => StockPage(
                              stockCode: stockName,
                              stockName: stockName,
                            ),
                          ));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
