import 'package:flutter/material.dart';
import 'package:proj/local_notifications/notif.dart';
import 'package:proj/main.dart';

class LocalNotifications extends StatefulWidget {
  const LocalNotifications({super.key});

  @override
  State<LocalNotifications> createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
TextEditingController titleController=TextEditingController();
TextEditingController descController=TextEditingController();

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
@override
  void initState() {
   Notif.initialNotiSettigs(flutterLocalNotificationsPlugin );
     
    super.initState();
  }

  void showNotification(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Local Notification"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                label: Text("notification title")
              ),
            ),
            const SizedBox(height: 20,),
              TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                label: Text("notification description")
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
         Notif.showBigTextNotification(title: "hello", body: "body", fn: flutterLocalNotificationsPlugin); ///
            }, child: const Text("save"))


          ],
        ),
      ),
    );
  }
}
