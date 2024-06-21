import 'package:flutter/material.dart';

class NotiHome extends StatefulWidget {
  const NotiHome({super.key});

  @override
  State<NotiHome> createState() => _NotiHomeState();
}

class _NotiHomeState extends State<NotiHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("push notification"),),
      body: Container(
        alignment: Alignment.center,
        child: Text("Home" ,style: TextStyle(color: Colors.black,fontSize: 20),),
      ),
    );
  }
}