// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class FaceAuth extends StatefulWidget {
//   const FaceAuth({super.key});

//   @override
//   State<FaceAuth> createState() => _FaceAuthState();
// }

// class _FaceAuthState extends State<FaceAuth> {

//   Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult loginResult = await FacebookAuth.instance.login();

//   // Create a credential from the access token
//   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

//   // Once signed in, return the UserCredential
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: Text("faceBook Authentication"),),
//       body: Center(child: ElevatedButton(onPressed: (){
//        signInWithFacebook();
//       }, child: Text("SignUp with Facebook")),),
//     );
//   }
// }

