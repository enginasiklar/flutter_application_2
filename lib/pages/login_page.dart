import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  LoginPage({super.key});
  @override  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) { return Scaffold(
              body: Center( child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {UserCredential? userCredential = await _auth.signInWithGoogle(); },
                    child: const Text('Login with Google'),   ),),),);} else {
            return ProfilePage(user: user);}} else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), );}},);}}


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);    }  }
  @override  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Text('Welcome ${user.displayName}',
              style: const TextStyle(fontSize: 24), ),
            const SizedBox(height: 16),
            ElevatedButton( onPressed: () => _logout(context),
              child: const Text('Logout'),    ),    ],   ), ),  );  }
}

