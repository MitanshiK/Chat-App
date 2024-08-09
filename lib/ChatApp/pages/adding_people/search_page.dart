

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chatrooms/chat_room.dart';
import 'package:proj/ChatApp/pages/invite.dart';
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
  ///////////////
      TextEditingController inviteController = TextEditingController();
    String inviteType = "email";
 
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
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          children: [
             Container(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color:  const Color.fromARGB(255, 226, 239, 246),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6,left: 6),
                            child: const Icon(Icons.search)
                          ),
                        ),
                        Expanded(
                          child: TextField(
                           autofocus: true,
                           controller: searchFieldController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: "Search chats ,Friends and emails",
                                suffix: GestureDetector(
                                  onTap: (){
                                    searchFieldController.clear();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    child: const Visibility(
                                      visible: true,
                                      child:Icon(Icons.close)
                                    ),
                                  ),
                                ),
                                
                                ),
                              
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: 
                   const Text("cancel", ),
                )
              ],
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
                          
                          title: Text(searchData.name.toString(),style: const TextStyle(fontFamily:"EuclidCircularB")),
                          subtitle: Text(searchData.email.toString(),style: const TextStyle(fontFamily:"EuclidCircularB")),
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
                        return Column(
                          children: [
                            const Text("No result Found",style: TextStyle(fontFamily:"EuclidCircularB")),
                            const SizedBox(height: 50,),
                            ElevatedButton(
                                style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(15)),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(255, 226, 239, 246))),
                              onPressed: (){
                              // InviteDialog(); 
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>Invites(userModel: widget.userModel,)));
                            }, child: const Text("Invite Friends", style: TextStyle(color: Colors.black),))
                          ],
                        );
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