import 'package:flutter/material.dart';

import '../main_home_view.dart';

class ErrPageView extends StatelessWidget {
  const ErrPageView({super.key});
  static String title = "/err";
  static String errorCode = "";

  @override
  Widget build(BuildContext context) {
    final String? args = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash_rounded,
              size: 100,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              errorCode,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  wordSpacing: 2,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.lightBlueAccent)),
                onPressed: () {
                  Navigator.popAndPushNamed(context, MainHomeView.title);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Reload",
                    style: TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
