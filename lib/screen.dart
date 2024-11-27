import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireAnyo extends StatelessWidget {
  const FireAnyo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
         
              onPressed: () => signInAnonymously(),
              child: const Text('Sign In'),
            ),
          ),
        ),
    
    );
  }
void signInAnonymously() async {
    try {
      final authResult = await FirebaseAuth.instance.signInAnonymously();
      debugPrint('${authResult.user?.uid}');
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}