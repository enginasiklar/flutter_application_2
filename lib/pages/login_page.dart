import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // user is not logged in
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential? userCredential =
                        await _auth.signInWithGoogle();
                      } catch (e) {
                        print('Login Error: $e');
                      }
                    },
                    child: const Text('Login with Google'),
                  ),
                ),
              ),
            );
          } else {
            // user is already logged in
            return ProfilePage(user: user);
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}