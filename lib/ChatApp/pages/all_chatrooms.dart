import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chat_room.dart';
import 'package:proj/ChatApp/pages/groupchatroom.dart';
import 'package:proj/ChatApp/pages/search_page.dart';

class AllChatRooms extends StatefulWidget {
  const AllChatRooms({super.key , required this.firebaseUser, required this.userModel});
   final UserModel userModel;
  final User firebaseUser; // firebase auth user

  @override
  State<AllChatRooms> createState() => _AllChatRoomsState();
}

class _AllChatRoomsState extends State<AllChatRooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,clipBehavior: Clip.none,
        title:  Text("Share" ,style: TextStyle(fontFamily:"EuclidCircularB"))),
      body: Container(
        width:  MediaQuery.sizeOf(context).width/1.1,
        height: MediaQuery.sizeOf(context).height/1.6,
        // constraints: BoxConstraints(
        //   maxHeight:MediaQuery.sizeOf(context).height/1.6
        // ,maxWidth: MediaQuery.sizeOf(context).width/2),
        child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("participantsId.${widget.userModel.uId}", isEqualTo: true)
                    .snapshots(), // get the chatroom that contain current User
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    
                      return ConstrainedBox(
                         constraints: BoxConstraints(
          maxHeight:MediaQuery.sizeOf(context).height/3
        ,maxWidth: MediaQuery.sizeOf(context).width/1.2),
                        child: ListView.builder(
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
                                   
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(8),
                                      onTap: () {
                                 
                                      },
                                      title: Text(userData.name.toString()  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            const Color.fromARGB(255, 158, 219, 241),
                                        backgroundImage: NetworkImage(
                                            userData.profileUrl.toString()),
                                      ),
                                          trailing: Icon(Icons.circle_outlined)
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
                        ),
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

              /// all groups 
               Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("GroupChats")
                .where("participantsId.${widget.userModel.uId}", isEqualTo: true)
                .snapshots(), // get the chatroom that contain current User
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
      
                  return (dataSnapshot.docs.isNotEmpty) 
                  ? ConstrainedBox(
                         constraints: BoxConstraints(
          maxHeight:MediaQuery.sizeOf(context).height/1.6
        ,maxWidth: MediaQuery.sizeOf(context).width/1.2),
                    child: ListView.builder(
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        GroupRoomModel groupRoomModel = GroupRoomModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                    
                    
                                return StreamBuilder(
                                  stream:  FirebaseFirestore.instance
                                            .collection("ChatAppUsers")
                                            .where("uId", isEqualTo: groupRoomModel.lastMessageBy)
                                             .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  
                                     if (snapshot.hasData){   
                                         QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                                  return  ListTile(
                                    onTap: () async{
                                  
                                  
                                    },
                                    title: Text(groupRoomModel.groupName.toString() ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                                    leading: CircleAvatar(
                                       radius: 25,
                                      backgroundColor:
                                          const Color.fromARGB(255, 158, 219, 241),
                                      backgroundImage: NetworkImage(
                                         groupRoomModel.profilePic.toString()),
                                    ),
                                   
                                        trailing: Icon(Icons.circle_outlined),
                                  );
                              
                                  }else{
                                    return const Text("no data"  ,style: TextStyle(fontFamily:"EuclidCircularB")  );
                                  }
                                  
                                  }
                                );
                      },
                    ),
                  )
                  :Text("no data");
      
                  /////
                } else if (snapshot.hasError) {
                  return Text("has error ${snapshot.error}");
                } else {
                  return  Text("no data");
                }
              } else {
                return const Center(
                   child: CircularProgressIndicator(),
                );
              }
            },
          ),
         ),
            ],
           ),
      ),
    );

  }
}