

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chat_room.dart';
import 'package:proj/main.dart';

class SearchPage extends StatefulWidget {
  final User firebaseUser;
  final UserModel userModel;
  const SearchPage({super.key ,required this.firebaseUser ,required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchFieldController = TextEditingController();
 
 // this function will get the chatroom data with the target user if we have already had a chat
 // otherwise it creates a new chatroom with the target user
  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async{
  ChatRoomModel chatRoomModel;

  final chatroom= await FirebaseFirestore.instance.collection("chatrooms")
  .where("participantsId.${widget.userModel.uId}" ,isEqualTo: true)
  .where("participantsId.${targetUser.uId}",isEqualTo: true).get();

  if(chatroom.docs.isNotEmpty){
    // fetch existing one 
  var docData=chatroom.docs[0].data();
  ChatRoomModel existingChatRoomModel=ChatRoomModel.fromMap(docData);

  chatRoomModel =existingChatRoomModel; // for returning
  debugPrint("chatroom already exists");
  }
  else{
    // create new one 
  ChatRoomModel newChatRoomModel=ChatRoomModel(
    chatRoomId: uuid.v1(),
    lastMessage: "",
     lastTime:DateTime.now(),
    participantsId: {
     widget.userModel.uId.toString() :true,
     targetUser.uId.toString() :true
    }
  );  

  await FirebaseFirestore.instance.collection("chatrooms").doc(newChatRoomModel.chatRoomId).set(newChatRoomModel.toMap());
  chatRoomModel=newChatRoomModel;  // for returning

  debugPrint("new chatroom created ");
  }
  return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 125, 116),
        title: const Text("Search" ,style: TextStyle(fontFamily:"EuclidCircularB")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: TextField(
                style: TextStyle(fontFamily:"EuclidCircularB"),
                controller: searchFieldController,
                decoration: const InputDecoration(
                  hintText: "Search",
                ),
              ),
              // Button
              trailing: IconButton(
                onPressed: () {
                  setState(() {}); // to refresh
                },
                icon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .where("email", isEqualTo: searchFieldController.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data
                          as QuerySnapshot; // convert into type QuerySnapshot

                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userDataMap =
                            dataSnapshot.docs[0].data() as Map<String,
                                dynamic>; // convertig document data into map

                        UserModel searchData = UserModel.fromMap(
                            userDataMap); //  saving data of searched user in usermodel to usermodel 

                        return ListTile(
                          onTap: () async{
                          ChatRoomModel? chatRoomModel=await getChatRoomModel(searchData);
                             
                            if(chatRoomModel!=null){
                              Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                          firebaseUser: widget.firebaseUser,
                                          userModel: widget.userModel,
                                          targetUser: searchData,
                                          chatRoomModel: chatRoomModel,
                                        )));
                                        }
                          },
                          
                          title: Text(searchData.name.toString(),style: TextStyle(fontFamily:"EuclidCircularB")),
                          subtitle: Text(searchData.email.toString(),style: TextStyle(fontFamily:"EuclidCircularB")),
                          leading: CircleAvatar(
                              backgroundImage: (searchData.profileUrl != null)
                                  ? NetworkImage(
                                      searchData.profileUrl.toString())
                                  : null,
                              backgroundColor:
                                  const Color.fromARGB(255, 239, 125, 116),
                              child: (searchData.profileUrl == null)
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    )
                                  : null),
                        );
                      } else {
                        return const Text("No result Found",style: TextStyle(fontFamily:"EuclidCircularB"));
                      }
                    } else if (snapshot.hasError) {
                      return const Text("An error has occured",style: TextStyle(fontFamily:"EuclidCircularB"));
                    } else {
                      return const Text("");
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}


