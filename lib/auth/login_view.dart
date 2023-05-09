import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/auth/auth_method.dart';

import '../main_home_view.dart';
import 'err_page_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;
  static String title = "/login";

  String logoPath = "assets/images/GSlogoS.png";

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return RootPage(
        userName: auth.currentUser!.displayName!,
      );
    }
    if (kIsWeb) {
      logoPath = "images/GSlogoS.png";
    }
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logoPath,
              width: MediaQuery.of(context).size.shortestSide * 0.33,
              height: MediaQuery.of(context).size.shortestSide * 0.35,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Google Login",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.green.shade100),
                shape: const MaterialStatePropertyAll(
                  CircleBorder(),
                ),
              ),
              onPressed: () async {
                UserCredential? userCredential =
                    await AuthMethod.signInWithGoogle().then((value) {
                  if (value != null) {
                    Navigator.popAndPushNamed(
                      context,
                      MainHomeView.title,
                    );
                  } else {
                    Navigator.popAndPushNamed(context, ErrPageView.title);
                  }
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.g_mobiledata_rounded,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}