import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential;}

  Future<void> signOut() async {
    await _auth.signOut();}

  // get the current user
  User? getCurrentUser() {
    final User? user = _auth.currentUser;
    return user;}

  // listen for authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();}
