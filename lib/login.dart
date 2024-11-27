
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:proj/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final registerKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String message="No";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Form"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Form(
            key: registerKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(
                child: Text("Login"),
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
                  },
                  child: const Text("Login")),
                  const SizedBox(height: 20,),
                  
             Text(message)
            ])),
      ),
    );
  }

// email and password
  void registerUser() async {

    try {
      final credential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
         message="yes";
      });

      Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(username: email,))); 
    } 
    catch (e) {
      debugPrint("this is Exception : $e");
    }
  }
}
