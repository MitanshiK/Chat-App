import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/contacts_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/message_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/home_page.dart';
import 'package:proj/ChatApp/pages/login.dart';
import 'package:proj/ChatApp/pages/splash_screen.dart';
import 'package:proj/add_contact.dart';
import 'package:proj/emoji_keyboard.dart';
import 'package:proj/facebook/face_auth.dart';
import 'package:proj/firestore/add_data.dart';
import 'package:proj/firestore/listening_changes.dart';
import 'package:proj/firestore/show_data.dart';
import 'package:proj/github/github_auth.dart';
import 'package:proj/local_notifications/local_notif.dart';
import 'package:proj/local_notifications/notif.dart';
import 'package:proj/location_map.dart';
import 'package:proj/phone/phone_auth.dart';
import 'package:proj/phone/phone_auth2.dart';
import 'package:proj/ChatApp/pages/read_contacts.dart';
import 'package:proj/realtime_db/save.dart';
import 'package:proj/register.dart';
import 'package:proj/screen.dart';
import 'package:proj/storage/audioRecording/aaa.dart';
import 'package:proj/storage/audio_player.dart';
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
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin(); //for local notification

Uuid uuid =Uuid();  // creates unique id 
void  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try{
 Notif.initialNotiSettigs(flutterLocalNotificationsPlugin ); 
 debugPrint("noti initialized");
  }catch(e){
    debugPrint("could no initialize $e");
  }
  
  User? currentUser = FirebaseAuth.instance.currentUser; // getting current user
  //initialize
  if (currentUser != null) {

    UserModel? userModel = await FirebaseHelper.getUserModelById(currentUser.uid); // getting data of user using userId
   
   if(userModel!=null){

      await FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("participantsId.${userModel.uId}", isEqualTo: true)
                    .snapshots().listen((event) { 
                    

                        for(var i in event.docs){

             ChatRoomModel chatRoom = ChatRoomModel.fromMap(  // getting chatroom
                          i.data());

                     FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(chatRoom.chatRoomId)
                    .collection("messages") .orderBy("createdOn",
                        descending:
                            true).snapshots().listen((event) async{

                 

                      // MessageModel message=MessageModel.fromMap(  // getting chatroom
                      //     event.docs.reversed.last .data() as Map<String, dynamic>); 
                      /// for type of message
                       
                      var dt = event.docs.reversed.last .data(); // map of data at particular index
                          // var a=dt[index];
                          late final message;
                         late final messageType;

                          ///

                          if (dt.containsValue("text") == true ) {
                          
                            // if message is text
                            message = MessageModel.fromMap(
                                event.docs.reversed.last.data());

                    UserModel? sender1 = await FirebaseHelper.getUserModelById(message.senderId);

                       // if current user is not the user who sent the message , 
                     // the message is sent in the same minute as now time 
                     // both user are in part of same chatroom then send the notification       
                        if(userModel.uId != message.senderId && message.createdOn!.minute ==DateTime.now().minute){
                              Notif.showBigTextNotification(title: sender1!.name!, body: message.text.toString(), fn: flutterLocalNotificationsPlugin);
                          }
                                
                          } else if (dt.containsValue("image") == true ||
                              dt.containsValue("video") == true ||
                              dt.containsValue("audio") 
                             ) {
                            message = MediaModel.fromMap(
                                event.docs.reversed.last.data());


                             if(userModel.uId != message.senderId && message.createdOn!.minute ==DateTime.now().minute){
                              if (dt.containsValue("image") == true) {
                              messageType = "image";
                          
                                  Notif.showBigTextNotification(title: "new Message", body: "image Recieved", fn: flutterLocalNotificationsPlugin);
                          
                              debugPrint(" its an image $messageType");
                            } else if (dt.containsValue("video") == true) {
                              messageType = "video";
                               Notif.showBigTextNotification(title: "new Message", body: "video Recieved", fn: flutterLocalNotificationsPlugin);
                            } else if (dt.containsValue("audio")) {
                              messageType = "audio";
                               Notif.showBigTextNotification(title: "new Message", body: "audio message Recieved", fn: flutterLocalNotificationsPlugin);
                            }
                            }

                          } else  if(dt.containsValue("contact")==true){  // for contact
                             message = ContactModal.fromMap(
                                event.docs.reversed.last.data());
                            messageType = "contact";
                          }
//////////////////
                  
                  // // getting senders info         // not in work
                  // UserModel senderData; 
                  //  FirebaseFirestore.instance
                  //   .collection("ChatAppUsers")
                  //   .where("participantsId.${message.senderId}", isEqualTo: true).snapshots().first.then((value) {
                  //        senderData=UserModel.fromMap(  
                  //          value.docs.first.data() as Map<String, dynamic>);
                  //            debugPrint("${senderData.name} is the sender");
                  //   });
                  
                    });
                     
              } // 1st for loop
                    });

    /////////////////////////for groups notification
                  

              await FirebaseFirestore.instance
                    .collection("GroupChats")
                    .where("participantsId.${userModel.uId}", isEqualTo: true)
                    .snapshots().listen((event) { 
                    

                        for(var i in event.docs){

             GroupRoomModel groupRoom = GroupRoomModel.fromMap(  // getting chatroom
                          i.data());

                     FirebaseFirestore.instance
                    .collection("GroupChats")
                    .doc(groupRoom.groupRoomId)
                    .collection("messages") .orderBy("createdOn",
                        descending:
                            true).snapshots().listen((event) async{

                     /// for type of message
                      var dt = event.docs.reversed.last .data(); // map of data at particular index
                          // var a=dt[index];
                          late final message;
                         late final messageType;

                          ///
                          if (dt.containsValue("text") == true ) {
                          
                            // if message is text
                            message = MessageModel.fromMap(
                                event.docs.reversed.last.data());

                      // for the senderdata
                       UserModel? sender = await FirebaseHelper.getUserModelById(message.senderId);
                 
                       // if current user is not the user who sent the message , 
                     // the message is sent in the same minute as now time 
                     // both user are in part of same chatroom then send the notification       
                        if(userModel.uId != message.senderId && message.createdOn!.minute ==DateTime.now().minute){
                              print("name of sender is ${sender!.name}");
                              Notif.showBigTextNotification(title: groupRoom.groupName!, body: "${sender.name!}: ${message.text.toString()}", fn: flutterLocalNotificationsPlugin);
                          }
                                
                          } else if (dt.containsValue("image") == true ||
                              dt.containsValue("video") == true ||
                              dt.containsValue("audio") 
                             ) {
                            message = MediaModel.fromMap(
                                event.docs.reversed.last.data());


                             if(userModel.uId != message.senderId && message.createdOn!.minute ==DateTime.now().minute){
                              if (dt.containsValue("image") == true) {
                              messageType = "image";
                          
                             Notif.showBigTextNotification(title: "new Message", body: "image Recieved", fn: flutterLocalNotificationsPlugin);
                          
                              debugPrint(" its an image $messageType");
                            } else if (dt.containsValue("video") == true) {
                              messageType = "video";
                               Notif.showBigTextNotification(title: "new Message", body: "video Recieved", fn: flutterLocalNotificationsPlugin);
                            } else if (dt.containsValue("audio")) {
                              messageType = "audio";
                               Notif.showBigTextNotification(title: "new Message", body: "audio message Recieved", fn: flutterLocalNotificationsPlugin);
                            } 
                            }

                          } else  if(dt.containsValue("contact")==true){  // for contact
                             message = ContactModal.fromMap(
                                event.docs.reversed.last.data());
                            messageType = "contact";
                          }
                  
                    });
                     
              } // 1st for loop
                    });


   runApp(
  //  MaterialApp(home: LocalNotifications())
    MyAppLoggedIn(
      firebaseUser:currentUser,
      userModel: userModel,
    )
    );
   }else{
     runApp( MyApp());
   }
 
  
  } else {
    runApp(MyApp());
  }
}

// if no user is  logged in
class MyApp extends StatelessWidget {
   MyApp({super.key });


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:SplashScreen(destination: 'login'),
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
        home:SplashScreen(destination: 'home', firebaseUser: firebaseUser, userModel: userModel,),
      ),
    );
  }


}
//    Future notifStream()async{


//   await FirebaseFirestore.instance
//                     .collection("chatrooms")
//                     .where("participantsId.${userModel.uId}", isEqualTo: true)
//                     .snapshots().listen((event) { 

//                         // ChatRoomModel chatRoom = ChatRoomModel.fromMap(
//                         // event.docs[0].data()
//                         //     as Map<String, dynamic>);

//                      Notif.showBigTextNotification(title: "hello", body: "body", fn: flutterLocalNotificationsPlugin); ///
//                     });
// }