import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/home_page.dart';
import 'package:proj/ChatApp/pages/login.dart';
import 'package:proj/facebook/face_auth.dart';
import 'package:proj/firestore/add_data.dart';
import 'package:proj/firestore/listening_changes.dart';
import 'package:proj/firestore/show_data.dart';
import 'package:proj/github/github_auth.dart';
import 'package:proj/phone/phone_auth.dart';
import 'package:proj/phone/phone_auth2.dart';
import 'package:proj/push_notif/noti_home.dart';
import 'package:proj/push_notif/notification.dart';
import 'package:proj/push_notif/push_noti_services.dart';
import 'package:proj/realtime_db/save.dart';
import 'package:proj/register.dart';
import 'package:proj/screen.dart';
import 'package:proj/storage/download_from_storage.dart';
import 'package:proj/storage/strorage.dart';
import 'package:proj/video_picker.dart';
import 'package:proj/video_player.dart';
import 'package:uuid/uuid.dart';

// final navigatorKey=GlobalKey<NavigatorState>();  // Navigator key to navigate

// Future<void> main() async{
//    WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

// // for push notifications
//   await  PushNotiServices().initialize();

//  ///////////

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {

//     return  MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       navigatorKey: navigatorKey,
//       home:  Loginpage(),
//     );

// for push notif
/*  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home:  NotiHome(),
      routes: {
      Notif.route:(context)=> const Notif()      // route variable declared in ShowData class;
      },
    );*/
////end
//   }
// }

//////////////////////////////////////chat app

Uuid uuid =Uuid();  // creates unique id 
void  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser; // getting current user

  if (currentUser != null) {

    UserModel? userModel = await FirebaseHelper.getUserModelById(currentUser.uid); // getting data of user using userId
   
   if(userModel!=null){
   runApp(
    MyAppLoggedIn(
      firebaseUser:currentUser,
      userModel: userModel,
    ));
   }else{
     runApp(const MyApp());
   }
 
  
  } else {
    runApp(const MyApp());
  }
}

// if no user is  logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Loginpage(),
    );
  }
}

// if user already logged in
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return KeyboardEmojiPickerWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(
          firebaseUser: firebaseUser,
          userModel: userModel,
        ),
      ),
    );
  }
}
