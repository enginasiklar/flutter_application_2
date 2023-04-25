import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePageTest extends StatefulWidget {
  const ProfilePageTest({super.key});
  @override
  State<ProfilePageTest> createState() => _ProfilePageTestState();
}

class _ProfilePageTestState extends State<ProfilePageTest> {
  Future<UserCredential?> signInWithGoogle() async {
    // Create an instance of the firebase auth and google signin
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    //Triger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    //Create a new credentials
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //Sign in the user with the credentials
    final UserCredential userCredential =
    await auth.signInWithCredential(credential);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await signInWithGoogle();
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              }
            },
            child: const Text('Login with Google'),
          ),
        ),
      ),
    );
  }
}
