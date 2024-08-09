import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/contacts_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/message_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/splash_screen.dart';

import 'package:proj/local_notifications/notif.dart';

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
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin(); //for local notification

// Uuid uuid =Uuid(); 
// /*
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
class MyApp extends StatefulWidget {
   MyApp({super.key });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
class MyAppLoggedIn extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<MyAppLoggedIn> createState() => _MyAppLoggedInState();
}

class _MyAppLoggedInState extends State<MyAppLoggedIn> with WidgetsBindingObserver {
  ///////////////////////////
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTime = DateTime.now();
    } else if (state == AppLifecycleState.paused ||
               state == AppLifecycleState.detached) {
      _endTime = DateTime.now();
      _calculateTimeOpen();
    }
  }

  void _calculateTimeOpen() {
    if (_startTime != null && _endTime != null) {
      final duration = _endTime!.difference(_startTime!);
      print('App was open for: ${duration.inSeconds} seconds');
      savetimeData(duration);
    }
  }

//// saving screen time to firebase
  void savetimeData(Duration totDuration) async{
  print(" inside saveTime fun");
 String curDate="${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

DocumentSnapshot<Map<String, dynamic>>? result;
Map<String, dynamic>? todaytime;
int prevDuration=0;

 ////getting
 try{
   result= await FirebaseFirestore.instance.collection("ChatAppUsers")
               .doc(widget.userModel.uId).collection("screenTime").doc(curDate).get();
              //  .where("${curDate}" ,isGreaterThan: 0).get();
   todaytime = await result.data();
     print("result1 is ${result.data()} , todaytime ");
   // print("result1 is ${result.data()!.keys.first} , todaytime ${result.data()![curDate]}");
    }catch(e){
      print("the error in getting result is $e");
    }
 print("outside try");

  if(result!.data()!=null){
    //  print("result2 is ${todaytime![curDate]}");
//  final docData=todaytime[curDate];
     prevDuration=result.data()![curDate];
     int newDuration=totDuration.inSeconds+ prevDuration;
     print("value of prevDuration is $prevDuration , new duration is $newDuration" );


   Map<String,int> newScreenTime={
    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}" : newDuration
   };
       await FirebaseFirestore.instance.collection("ChatAppUsers")
  .doc(widget.userModel.uId).collection("screenTime").doc(curDate).update(newScreenTime);
    //  final docData=result.docs[0].data()[curDate];
  }

 if(result.data()==null){
   print("inside if null");
    ///creating
   Map<String,int> screenTime={
    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}" : totDuration.inSeconds
   };
try{
  await FirebaseFirestore.instance.collection("ChatAppUsers")
  .doc(widget.userModel.uId).collection("screenTime").doc(curDate).set(screenTime);
  }catch(e){
    print("could not create screentime $e");
  }
  // chatRoomModel=newChatRoomModel;  // for returning
}

  // result.docs.first.data();
  }
  //////////////////////////

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
        home:SplashScreen(destination: 'home', firebaseUser: widget.firebaseUser, userModel: widget.userModel,),
      ),
    );
  }
}
// */
//////////////////////////////////////chat app
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
////////////////////////////////

// void main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// runApp(const ProviderScope(child: MyApp()));
// } 

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {

//     return  MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shopping Cart',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Screen1(),
//     );
//   }
// }