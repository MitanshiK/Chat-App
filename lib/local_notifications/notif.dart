
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:proj/main.dart';

class Notif{

  static Future initialNotiSettigs(FlutterLocalNotificationsPlugin FlutterLocalNotificationsPlugin) async{

  var androidInitializationSettings=const AndroidInitializationSettings("mipmap/chat_app_logo");
      // var iosInitializationSettings =
      //   IOSInitializationSettings();  // for IOS

     var initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: null,
      macOS: null,
      linux: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification({var id=0,required String title ,required String body ,var payload ,required FlutterLocalNotificationsPlugin fn})async{
    AndroidNotificationDetails androidPlatformChannelSpecifics =const AndroidNotificationDetails(
      "Ch1",
      "Channel1",
      playSound: true,
      // sound: RawResourceAndroidNotificationSound("notification"),
      importance: Importance.max,
      priority: Priority.high 
    );

  var not=NotificationDetails(android: androidPlatformChannelSpecifics);
   await fn.show(0, title, body, not);

  }
 

}