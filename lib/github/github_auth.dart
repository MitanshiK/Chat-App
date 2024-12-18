// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:github_sign_in_plus/github_sign_in_plus.dart';
// // import 'package:proj/home.dart';

// // class GithubAuth extends StatefulWidget {
// //   const GithubAuth({super.key});

// //   @override
// //   State<GithubAuth> createState() => _GithubAuthState();
// // }

// // class _GithubAuthState extends State<GithubAuth> {
// //   @override
// //   Widget build(BuildContext context) {
// //        return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(title: Text("faceBook Authentication"),),
// //       body: Center(child: ElevatedButton(
// //         onPressed: ()async{
       

// // { 
// //           final GitHubSignIn gitHubSignIn = GitHubSignIn( 
// //               clientId: "Ov23ctfW3oGsOmkojNUu" ?? "", 
// //               clientSecret: "e5cc668080341d8e53cc2970a7f323012fb06629" ?? "", 
// //               redirectUrl:"https://flutter1-a89ae.firebaseapp.com/__/auth/handler" ?? ""); 
// //           // From this we will be redirect to login page 
// //           // of github to get the token 
// //           var result = await gitHubSignIn.signIn(context); 
// //           // To get status whether user is logged in or not 
// //           switch (result.status) { 
// //             // If it is success it will come here 
// //             case GitHubSignInResultStatus.ok: 
// //               debugPrint("Success  ${result.token}");
// //               setState(() {}); 
// //               break; 
  
// //             case GitHubSignInResultStatus.cancelled: 
// //             // If it is cancelled by user it will come here 
// //             case GitHubSignInResultStatus.failed: 
// //               // If it is failed due to any 
// //               // reason it will come here 
// //               debugPrint(result.errorMessage); 
// //               break; 
// //           } 
// //         }



// // ///
// //     //  try{
// //     //   UserCredential userCredential=await signInWithGihub();
// //     // if(context.mounted){
// //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(username: userCredential.user!.displayName.toString()) ));
// //     // }
// //     // }catch(e){
// //     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()} error occurred")));
// //     //   debugPrint("error is $e");
// //     // }
// //       }, child: Text("SignUp with Github")),),
// //     );
// //   }
  
// // Future<UserCredential> signInWithGihub() async {
// //   // Create a new provider
// //   GithubAuthProvider githubProvider = GithubAuthProvider();

// //   return await FirebaseAuth.instance.signInWithProvider(githubProvider);
// // }
// // }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:github_sign_in_plus/github_sign_in_plus.dart';
// import 'package:proj/home.dart';

// class GithubAuth extends StatefulWidget {
//   const GithubAuth({super.key});

//   @override
//   State<GithubAuth> createState() => _GithubAuthState();
// }

// class _GithubAuthState extends State<GithubAuth> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: const Text("GitHub Authentication")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final GitHubSignIn gitHubSignIn = GitHubSignIn(
//               clientId: "Ov23ctfW3oGsOmkojNUu",
//               clientSecret: "e5cc668080341d8e53cc2970a7f323012fb06629",
//               redirectUrl: "https://flutter1-a89ae.firebaseapp.com/__/auth/handler",
//             );

//             var result = await gitHubSignIn.signIn(context);

//             switch (result.status) {
//               case GitHubSignInResultStatus.ok:
//                 debugPrint("GitHub Sign-In Success, token: ${result.token}");
//                 try {
//                   // Create Firebase Auth credential using GitHub token
//                   AuthCredential credential = GithubAuthProvider.credential(result.token!);
                  
//                   // Sign in to Firebase with the GitHub credential
//                   UserCredential userCredential = await _auth.signInWithCredential(credential);

//                   // Access the signed-in user
//                   User? user = userCredential.user;

//                   if (user != null) {
//                     debugPrint("Firebase Sign-In Success, user: ${user.displayName}, email: ${user.email}");
//                     // Navigate to the home screen
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) =>  Home(username: 'name',)),
//                     );
//                   }
//                 } catch (e) { 
//                   debugPrint("Firebase Sign-In Failed: $e");
//                 }
//                 break;

//               case GitHubSignInResultStatus.cancelled:
//                 debugPrint("GitHub Sign-In Cancelled");
//                 break;

//               case GitHubSignInResultStatus.failed:
//                 debugPrint("GitHub Sign-In Failed: ${result.errorMessage}");
//                 break;
//             }
//           },
//           child: const Text("Sign Up with GitHub"),
//         ),
//       ),
//     );
//   }
// }
