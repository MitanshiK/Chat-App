import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth2 {

  // sign In function
  static Future<User?> signInWithGoogleFunc(
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      // its true if our app is compiled to run on web , we check this so that we can show popup for google sign in
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth
            .signInWithPopup(googleAuthProvider); // shows popup to select email

        user = userCredential.user; // gets the email selected
      } catch (e) {
       print(e);
      }
    } else {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(); // initialised google signIn settings

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn(); // starts sign In process and gets an istance of googleSignIn account if signIn is successful otherwise returns null

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          final UserCredential userCredential = await auth.signInWithCredential(
              authCredential); // sign in using google credientials

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          // gets exceptions in firebase auth
          debugPrint(e.code);
        }
      }
    }

    return user;
  }


  // sign out function 
  static Future<void> signOutGoogle(BuildContext context)async {
        FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =GoogleSignIn();
   
   try{
    if(kIsWeb){
   await googleSignIn.signOut();
    }
    await auth.signOut();
  Navigator.pop(context);
   }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error Cannot sign out")));
    debugPrint(" sign out error $e");

   }

  }
}
