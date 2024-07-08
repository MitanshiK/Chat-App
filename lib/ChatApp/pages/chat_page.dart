import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chat_room.dart';
import 'package:proj/ChatApp/pages/search_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key , required this.firebaseUser, required this.userModel});
   final UserModel userModel;
  final User firebaseUser; // firebase auth user

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,clipBehavior: Clip.none,
        title:  GestureDetector(
                                onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel,)));
                                },
            child:  Container(
              margin: EdgeInsets.only(top: 5),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color:  Color.fromARGB(255, 226, 239, 246),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.search)
                              // const Image(
                              //   image: AssetImage("assets/Search.png"),
                              //   width: 24,
                              //   height: 24,
                              // ),
                            ),
                            const Expanded(
                                child: Text( "Search Chats ,friends",style: TextStyle(fontSize: 15 ,fontFamily:"EuclidCircularB"),)
                 
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            )),
      body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participantsId.${widget.userModel.uId}", isEqualTo: true)
                .snapshots(), // get the chatroom that contain current User
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
      
                  return ListView.builder(
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>);
      
                       // to get targetUser Id
                      Map<String, dynamic> participants =
                          chatRoomModel.participantsId!; // getting participants
                      List<String> participantsList = participants.keys
                          .toList(); // getting participants keys and saving in list
                      participantsList.remove(widget.userModel
                          .uId);  // removing currentUser key so that we are left with targetuser id
                              /////
               
      
                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(
                            participantsList[0]), // passing target user id
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              UserModel userData = snapshot.data as UserModel;
                              String toShow;
                              String msgDate="${chatRoomModel.lastTime!.day}/${chatRoomModel.lastTime!.month}/${chatRoomModel.lastTime!.year}";
                              String currentDate="${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                               
                               print("${currentDate.compareTo(msgDate)}");
      
                               if(currentDate.compareTo(msgDate)==0){
        
                                String msgTime="${chatRoomModel.lastTime!.hour}:${chatRoomModel.lastTime!.minute}";
                                String curTime="${DateTime.now().hour}:${DateTime.now().minute}";
      
                                // inner if start
                                if(msgTime==curTime){
                                  toShow="now";
                                }
                                else{
                                  toShow=msgTime;
                                }// inner if close
      
                               }else{
                                toShow =msgDate;
                               }
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatRoomPage(
                                                firebaseUser: widget.firebaseUser,
                                                userModel: widget.userModel,
                                                targetUser: userData,
                                                chatRoomModel: chatRoomModel,
                                              )));
                                },
                                title: Text(userData.name.toString()  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      const Color.fromARGB(255, 158, 219, 241),
                                  backgroundImage: NetworkImage(
                                      userData.profileUrl.toString()),
                                ),
                                subtitle: (chatRoomModel.lastMessage.toString() !=
                                        "")
                                    ? Text(chatRoomModel.lastMessage.toString()  ,style: TextStyle(fontFamily:"EuclidCircularB")  )
                                    : const Text("Say Hello"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                                    trailing: Text(toShow  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
      
                  /////
                } else if (snapshot.hasError) {
                  return const Center(child: Text(" Please check your network"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ));
                } else {
                  return const Center(child: Text(" no chats"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
         ),
    );

  }
}