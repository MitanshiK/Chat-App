import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      // A constant that is true if the application was compiled to run on the web.
      GoogleAuthProvider authProvider =
          GoogleAuthProvider(); // to create a new google crediential

      try {
        final UserCredential userCredential = await auth.signInWithPopup(
            authProvider); // using auth provider instance to show popup to show device's emails

        user = userCredential.user; // to get the email choosen
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(); // initializes sign in settings

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn(); // gets an istance of googleSignIn account if signIn is successful otherwise returns null

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(
              credential); // used to sign in using google / facebook etc
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            debugPrint(" account already exists with different credentials");
          } else if (e.code == 'invalid-credential') {
            debugPrint("invalid credentials");
          }
        } catch (e) {
          print(e);
        }
      }
    }

    return user;
  }
}
