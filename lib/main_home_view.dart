import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/err_page_view.dart';
import 'auth/login_view.dart';
import 'main.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});
  static String title = "/";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return LoginView();
          } else {
            return RootPage(
                userName:
                    FirebaseAuth.instance.currentUser!.displayName ?? "guest");
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
