import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'err_page_view.dart';

class AuthMethod {
  static Future<void> logout() async {
    if (kIsWeb) {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      return;
    }
    final GoogleSignIn googleSign = GoogleSignIn();
    await googleSign.signOut();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final UserCredential userCredential;
    // In case of web browser
    if (kIsWeb) {
      try {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } on PlatformException catch (e) {
        ErrPageView.errorCode = e.code;
        return null;
      }
    }
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      ErrPageView.errorCode = e.code;
      return null;
    }
  }
}
