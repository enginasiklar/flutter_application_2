import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/notifications/followed_stock_list_view.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/search/search_view.dart';
import 'package:flutter_application_2/pages/setting_view.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'firebase_options.dart';
import 'model/main_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Map<String, MainModel> mainData = await ApiService().fetchMainData();
  MainModel.data = mainData; // Set the mainData using the static setter
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('it')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      title: 'CashSpeeder',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const RootPage(title: 'CashSpeeder'),
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
  List<Widget> pages = [const HomePage(), LoginPage()];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.hasData;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                tooltip: tr('main.search'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SearchViewPage();
                    },
                  ));
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                tooltip: tr('main.setting'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SettingViewPage();
                    },
                  ));
                },
                icon: const Icon(Icons.settings),
              ),
              if (isLoggedIn)
                IconButton(
                  tooltip: tr('main.notification'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const FollowedStocksListView();
                      },
                    ));
                  },
                  icon: const Icon(Icons.notifications),
                ),
            ],
          ),
          body: pages[currentPage],
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home),
                label: tr('main.home'),
                tooltip: tr('main.home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person),
                label: tr('main.profile'),
                tooltip: tr('main.profile'),
              ),
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
      },
    );
  }
}
