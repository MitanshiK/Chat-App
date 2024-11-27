// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proj/google_sign/auth2.dart';


class Home extends StatelessWidget {
  Home({super.key , required this.username});
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Home Page"),),
      body: Center(child:
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Image(image: AssetImage("assets/album1.jpg"),),
           Text("welcome $username"),
           ElevatedButton(onPressed: () async{
            // if(Auth2.signOutGoogle(context)==true){
            // Navigator.pop(context);
            // }
            // else{
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured ")));
            // }
          await  GoogleAuth2.signOutGoogle(context);
          //   if(auth.User==null){
          //      Navigator.pop(context);
             
          //   }else{
          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured ${auth.User}")));
          //   }
           }
           , child: const Text("Google Sign Out "))
         ],
       ),),
    );
  }
}