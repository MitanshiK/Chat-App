import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});
    static const route='/show_data';   // for push notifications
    

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
  final message=ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("push notification"),),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text("notification" ,style: TextStyle(color: Colors.black,fontSize: 20),),
            SizedBox(height: 20,),
            Text("${message.toString()}")
          ],
        ),
      ),
    );
  }
}