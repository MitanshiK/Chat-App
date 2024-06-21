import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chat_room.dart';
import 'package:proj/ChatApp/pages/complete_profile.dart';
import 'package:proj/ChatApp/pages/login.dart';
import 'package:proj/ChatApp/pages/search_page.dart';


class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser; // firebase auth user
  const HomePage(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              //1
              PopupMenuItem(
                child: const ListTile(
                  title: Text("Log Out"),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut(); // to sign out
                  Navigator.popUntil(
                      context,
                      (route) => route
                          .isFirst); // pop pages until first page of app appears
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Loginpage())); // replace the current page and push the provided page
                },
              ),
              // 2
              PopupMenuItem(
                  child: const ListTile(
                title: Text("View profile"),
                leading: Icon(Icons.person),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CompleteUserProfile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
              },)
            ],
          )
        ],
        backgroundColor: const Color.fromARGB(255, 158, 219, 241),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Home Page"),
      ),
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
                        .uId); // removing currentUser key so that we are left with targetuser id
/////
                    return FutureBuilder(
                      future: FirebaseHelper.getUserModelById(
                          participantsList[0]), // passing target user id
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            UserModel userData = snapshot.data as UserModel;

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
                              title: Text(userData.name.toString()),
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 158, 219, 241),
                                backgroundImage: NetworkImage(
                                    userData.profileUrl.toString()),
                              ),
                              subtitle: (chatRoomModel.lastMessage.toString() !=
                                      "")
                                  ? Text(chatRoomModel.lastMessage.toString())
                                  : const Text("Say Hello"),
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
                return const Center(child: Text(" Please check your network"));
              } else {
                return const Center(child: Text(" no chats"));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPage(
                        firebaseUser: widget.firebaseUser,
                        userModel: widget.userModel,
                      )));
        },
        backgroundColor: const Color.fromARGB(255, 158, 219, 241),
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
