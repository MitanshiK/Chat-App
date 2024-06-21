// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:proj/main.dart';
// import 'package:proj/push_notif/notification.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title:${message.notification?.title}');
//   print('Body:${message.notification?.body}');
//   print('Payload:${message.data}');
// }

// // dP5SatgYR06_P30tqNz9yl:APA91bFvawcSwXi5tJT7WFOOZk1hlHaGRh3r60Pz77tUFXT5mZl271-aDA_5ubdtpCs2C4fn5AQEbybWjqG9fizA73ilVDnJ7cCn2bn_WsJ_LIHirgdVXg2OzB27wJrYbv6OP6D4zX7K
// class PushNotiServices {
//   final messaging = FirebaseMessaging.instance; //
 
// void handleMessage(RemoteMessage? message){
//   if(message == null){return;}  // if message is null , we exit

//   navigatorKey.currentState!.pushNamed(    // else we navigate to this page 
//     Notif.route,
//     arguments: message
//   );
// }

//   Future initPushNoti() async{
//  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   alert: true,
//   badge: true,
//   sound: true
//  );
// //  FirebaseMessaging.instance.getInitialMessage().then((value){
// //   handleMessage();
// //  });
//  FirebaseMessaging.instance.getInitialMessage().then(handleMessage); // responsible for performing an action when an app is opened from terminated state
//   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);  // responsible for performing an action when an app is opened from background state
//  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   }

//   Future<void> initialize() async {
//     final settings = await messaging.requestPermission(); //
//     String? token = await messaging.getToken(); //
//     print('Registration Token=$token'); //
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     initPushNoti();
//   }
// }
