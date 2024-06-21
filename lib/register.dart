import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:proj/google_sign/auth2.dart';
import 'package:proj/google_sign/authenti.dart';
import 'package:proj/home.dart';
import 'package:proj/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final registerKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registration Form"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Form(
            key: registerKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(
                child: Text("Register"),
              ),
              const SizedBox(
                height: 20,
              ),
              // email field
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: const InputDecoration(
                    label: Text("Email"),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12)),
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),

              // password field
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: const InputDecoration(
                    label: Text("Password"),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12)),
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                  onPressed: () async {
                    registerKey.currentState?.save();
                    registerUser(); // to registerUser
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                  },
                  child: const Text("Submit")),
                  SizedBox(height: 20,),
                  
                   ElevatedButton(
         
              onPressed: () => signInAnonymously(),
              child: Text('Sign In'),
            ),

            ElevatedButton(onPressed: ()async {
            auth.User? user= await GoogleAuth2.signInWithGoogleFunc(context: context) ;
              //  auth.User? user= await Authentication.signInWithGoogle(context: context) ;

              if(user!=null){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(username: user.displayName.toString(),)));
              }
            }, child: Text("Google Sign In"))
            ])),
      ),
    );
  }

// email and password
  void registerUser() async {
    try {
      final credential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("this is Exception : $e");
    }
  }
  // anonymous 
  void signInAnonymously() async {
    try {
      final authResult = await auth.FirebaseAuth.instance.signInAnonymously();
      print('${authResult.user?.uid}');
    } catch(e) {
      print(e.toString());
    }
  }
}
