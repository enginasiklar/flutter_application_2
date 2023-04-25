import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/notifications/followed_stock_list_view.dart';
import 'package:flutter_application_2/notifications/followed_stock_model.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page_test.dart';
import 'package:flutter_application_2/pages/search/search_view.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => FollowedStocksModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const RootPage(title: 'XFlutter Demo main title'),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.title});
  final String title;
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [HomePage(), ProfilePageTest()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              tooltip: "search",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  // return const stockPage();
                  return const SearchViewPage();
                }));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              tooltip: "Notifications",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  // return const stockPage();
                  return FollowedStocksListView();
                }));
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home), label: 'home', tooltip: 'home'),
          NavigationDestination(
              icon: Icon(Icons.person), label: 'profile', tooltip: 'profile'),
          //NavigationDestination(icon: Icon(Icons.call), label: 'call')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        height: 55,
      ),
    );
  }
}
