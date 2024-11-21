import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubit_form/cubit_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/Blocs/chat_selected_bloc.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/ui_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/main.dart';
import 'package:rxdart/rxdart.dart';

// in progress [not completed]
class AllChatRooms extends StatefulWidget {
  const AllChatRooms(
  { super.key,
    required this.firebaseUser,
    required this.userModel ,
    required this.type ,
    required this.mediaToSend });
  final UserModel userModel;
  final User firebaseUser; // firebase auth user
  final String type;
  final String mediaToSend;

  @override
  State<AllChatRooms> createState() => _AllChatRoomsState();
}

class _AllChatRoomsState extends State<AllChatRooms> {
 List<String> chatRoomIds = [];
 List<dynamic> roomModelList=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          clipBehavior: Clip.none,
          title:
              const Text("Share", style: const TextStyle(fontFamily: "EuclidCircularB"))),
      body: Column(
        children: [
          /// all groups
          Container(
            child:
                //    StreamBuilder(
                //     stream: FirebaseFirestore.instance
                //         .collection("GroupChats")
                //         .where("participantsId.${widget.userModel.uId}", isEqualTo: true)
                //         .snapshots(), // get the chatroom that contain current User
                //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //       if (snapshot.connectionState == ConnectionState.active) {
                //         if (snapshot.hasData) {
                //           QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                //           return (dataSnapshot.docs.isNotEmpty)
                //           ? ConstrainedBox(
                //                  constraints: BoxConstraints(
                //   maxHeight:MediaQuery.sizeOf(context).height/4
                // ,maxWidth: MediaQuery.sizeOf(context).width/1.2),
                //             child: ListView.builder(
                //               itemCount: dataSnapshot.docs.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 GroupRoomModel groupRoomModel = GroupRoomModel.fromMap(
                //                     dataSnapshot.docs[index].data()
                //                         as Map<String, dynamic>);
                //                         return StreamBuilder(
                //                           stream:  FirebaseFirestore.instance
                //                                     .collection("ChatAppUsers")
                //                                     .where("uId", isEqualTo: groupRoomModel.lastMessageBy)
                //                                      .snapshots(),
                //                           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //                              if (snapshot.hasData){
                //                                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                //                           return  ListTile(
                //                             onTap: () async{
                //                             },
                //                             title: Text(groupRoomModel.groupName.toString() ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
                //                             leading: CircleAvatar(
                //                                radius: 25,
                //                               backgroundColor:
                //                                   const Color.fromARGB(255, 158, 219, 241),
                //                               backgroundImage: NetworkImage(
                //                                  groupRoomModel.profilePic.toString()),
                //                             ),
                //                                 trailing: Icon(Icons.circle_outlined),
                //                           );
                //                           }else{
                //                             return const Text("no data"  ,style: TextStyle(fontFamily:"EuclidCircularB")  );
                //                           }
                //                           }
                //                         );
                //               },
                //             ),
                //           )
                //           :Text("no data");
                //           /////
                //         } else if (snapshot.hasError) {
                //           return Text("has error ${snapshot.error}");
                //         } else {
                //           return  Text("no data");
                //         }
                //       } else {
                //         return const Center(
                //            child: CircularProgressIndicator(),
                //         );
                //       }
                //     },
                //   ),

                StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
              stream: CombineLatestStream.list([
                FirebaseFirestore.instance
                    .collection("GroupChats")
                    .where("participantsId.${widget.userModel.uId}",
                        isEqualTo: true)
                    .snapshots(),
                FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("participantsId.${widget.userModel.uId}",
                        isEqualTo: true)
                    .snapshots()
              ]),
              builder: (context,
                  AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>>
                      snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                // Access your data from the snapshot
                List<QuerySnapshot<Map<String, dynamic>>> querySnapshots =
                    snapshot.data!;

                // Combine or process your query snapshots as needed
                // For example, you can flatten the documents from both collections
                List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocuments =[];
                for (QuerySnapshot<Map<String, dynamic>> querySnapshot
                    in querySnapshots) {
                  allDocuments.addAll(querySnapshot.docs);
                }
                   List<bool> selected=List.filled(allDocuments.length, false);
                // Display your combined data
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    itemCount: allDocuments.length,
                    itemBuilder: (context, index) {
                      var doc = allDocuments[index].data();
                       
                      List<String> participantsList =
                          getfriend(doc["participantsId"]);

                      // Build your widget for each document
                      return (doc["chatRoomId"] == null)
                          ? BlocProvider<ChatSelectedBloc>(
                            create: (_) => ChatSelectedBloc(false), 
                           child:  BlocBuilder<ChatSelectedBloc,bool>(
                               builder: (BuildContext context, state) {  
                               return ListTile(
                                  onTap: () async{    
                                    context.read<ChatSelectedBloc>().add(Chatselection());      ////////////////
                                      selected[index] = !selected[index];
                                   
                                       if (selected[index]==true) {
                                          // await   FirebaseFirestore.instance
                                          //  .collection("GroupChats")
                                          //  .doc(doc["groupRoomId"]).snapshots().listen((onData){

                                          //         ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                          //                         onData.data()   as Map<String, dynamic>);
                                          //         RoomModelList.add(chatRoomModel);           

                                          //  });
                                    
                                        chatRoomIds
                                            .add(doc["groupRoomId"].toString());
                                      }
                                      else if (selected[index]==false){
                                        
                                           chatRoomIds
                                            .remove(doc["groupRoomId"].toString());
                                      }
                                     debugPrint("chatRooom ${doc["groupRoomId"].toString()} selected value is ${selected[index]}");
                                  },
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        const Color.fromARGB(255, 158, 219, 241),
                                    backgroundImage:
                                        NetworkImage(doc["profilePic"].toString()),
                                  ),
                                  trailing: Icon((context.watch<ChatSelectedBloc>().state==true) 
                                      ? Icons.circle
                                      : Icons.circle_outlined),
                                  title: Text(doc[
                                      'groupName']), // Replace 'field_name' with your actual field name
                                  // Replace 'another_field' with your actual field name
                                );
                               }
                             ),
                             
                          )
                          : FutureBuilder(
                              future: FirebaseHelper.getUserModelById(
                                  participantsList[
                                      0]), // passing target user id
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    UserModel userData =
                                        snapshot.data as UserModel;
                                    return  BlocProvider<ChatSelectedBloc>(
                            create: (_) => ChatSelectedBloc(false), 
                           child:  BlocBuilder<ChatSelectedBloc,bool>(
                               builder: (BuildContext context, state) {  
                               return ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                        onTap: () async{
                                         context.read<ChatSelectedBloc>().add(Chatselection());    
                                            selected[index] = !selected[index];
                                         
                                            if (selected[index]==true) {
                                              chatRoomIds.add(
                                                  doc["chatRoomId"].toString());
                                            }  else if (selected[index]==false){
                                           chatRoomIds
                                            .remove(doc["chatRoomId"].toString());
                                      }


                                 debugPrint("chatRooom ${doc["groupRoomId"].toString()} selected value is ${selected[index]}");
                                        },
                                        title: Text(userData.name.toString(),
                                            style: const TextStyle(
                                                fontFamily: "EuclidCircularB")),
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: const Color.fromARGB(
                                              255, 158, 219, 241),
                                          backgroundImage: NetworkImage(
                                              userData.profileUrl.toString()),
                                        ),
                                        trailing: Icon((context.watch<ChatSelectedBloc>().state==true) 
                                            ? Icons.circle
                                            : Icons.circle_outlined));
                                  })
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
              },
            ),
          ),
        ],
      ),
       floatingActionButton: IconButton(
          onPressed: () async{
         
           await  checkRoomIds();
            Navigator.pop(context);
             UiHelper.loadingDialogFun(context, "sending Message......");
             ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sending Messages" ,style: TextStyle(fontFamily:"EuclidCircularB"))));
            
            debugPrint("chatrooms are $chatRoomIds");
          },
          icon: const Icon(
            Icons.send,
            color: Colors.blue,
            size: 40,
          )),
    );
  }

  List<String> getfriend(Map<String, dynamic> participants) {
    List<String> participantsList = participants.keys.toList();
    // getting participants keys and saving in list
    participantsList.remove(widget.userModel.uId);
    debugPrint("participant in combined list is ${participantsList[0]} ");

    return participantsList;
  }


Future checkRoomIds() async {
  Set<String> processedRoomIds = {}; // To keep track of processed room ids

  FirebaseFirestore.instance
      .collection("GroupChats")
      .snapshots()
      .listen((onData) {
    for (var i in onData.docs) {
      for (var j in chatRoomIds) {
        if (!processedRoomIds.contains(j)) {
          if (i["groupRoomId"] == j) {
            debugPrint("$j is a group");

            FirebaseFirestore.instance
                .collection("GroupChats")
                .doc(j)
                .get()
                .then((value) {
              GroupRoomModel groupRoomModel =
                  GroupRoomModel.fromMap(value.data() as Map<String, dynamic>);

              sendDataGroup(j, groupRoomModel); // sending data
            });

          } else {
            debugPrint("$j is not a group");

            FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(j)
                .get()
                .then((value) {
              ChatRoomModel chatRoomModel =
                  ChatRoomModel.fromMap(value.data() as Map<String, dynamic>);

              sendDataSingle(j, chatRoomModel); // sending data
            });
          }

          processedRoomIds.add(j); // Mark this room id as processed
        }
      }
    }
  });
}



Future sendDataSingle(String chatroomId ,ChatRoomModel chatroomMidel) async{
  late MediaModel newMessage;

final  result = await FirebaseStorage.instance
          .ref("AllSharedMedia")
          .child(chatroomId)
          .child("sharedMedia")
          .child(uuid.v1())
          .putFile(File(widget.mediaToSend));

       // getting the download link of image uploaded in storage
    String   mediaUrl = await result.ref.getDownloadURL();
       

      if (widget.type == "image") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "image");
      } else if (widget.type == "video") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "video");
      }

        FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .collection("messages")
          .doc(newMessage.mediaId)
          .set(newMessage.toMap())
          .then((value) {
        debugPrint("message sent");
      });

         // setting last message in chatroom and saving in firestore
      chatroomMidel.lastMessage = widget.type;
      chatroomMidel.lastTime=newMessage.createdOn; // time 
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .set(chatroomMidel.toMap());
}

Future sendDataGroup(String grouproomId ,GroupRoomModel grouproomMidel) async{
  late MediaModel newMessage;

final  result = await FirebaseStorage.instance
          .ref("AllSharedMedia")
          .child(grouproomId)
          .child("sharedMedia")
          .child(uuid.v1())
          .putFile(File(widget.mediaToSend));

       // getting the download link of image uploaded in storage
    String   mediaUrl = await result.ref.getDownloadURL();
       

      if (widget.type == "image") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "image");
      } else if (widget.type == "video") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "video");
      }

        FirebaseFirestore.instance
          .collection("GroupChats")
          .doc(grouproomId)
          .collection("messages")
          .doc(newMessage.mediaId)
          .set(newMessage.toMap())
          .then((value) {
        debugPrint("message sent");
      });

         // setting last message in chatroom and saving in firestore
      grouproomMidel.lastMessage = widget.type;
      grouproomMidel.lastTime=newMessage.createdOn; // time 
      grouproomMidel.lastMessageBy=newMessage.senderId;
      FirebaseFirestore.instance
          .collection("GroupChats")
          .doc(grouproomId)
          .set(grouproomMidel.toMap());
}
}
