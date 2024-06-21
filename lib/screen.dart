import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Fire_Anyo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Container(
            height: 50,
            width: 100,
            child: ElevatedButton(
         
              onPressed: () => signInAnonymously(),
              child: Text('Sign In'),
            ),
          ),
        ),
    
    );
  }
void signInAnonymously() async {
    try {
      final authResult = await FirebaseAuth.instance.signInAnonymously();
      print('${authResult.user?.uid}');
    } catch(e) {
      print(e.toString());
    }
  }
}