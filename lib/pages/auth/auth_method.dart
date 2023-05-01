import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethod {
  static Future<void> logout() async {
    if (kIsWeb) {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      return;
    }
    final GoogleSignIn googleSign = GoogleSignIn();
    await googleSign.signOut();
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final UserCredential userCredential;
    // In case of web browser
    if (kIsWeb) {
      // Create an instance of the firebase auth and google signin
      FirebaseAuth auth = FirebaseAuth.instance;
      // The `GoogleAuthProvider` can only be
      // used while running on the web
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        //Sign in the user with the credentials
        userCredential = await auth.signInWithPopup(authProvider);
        return userCredential;
      } catch (e) {}
      return null;
    }

    // Create an instance of the firebase auth and google signin
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {} catch (e) {
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
      userCredential = await auth.signInWithCredential(credential);
      return userCredential;
    }
    return null;
  }
}
