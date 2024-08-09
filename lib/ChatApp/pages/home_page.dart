import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/in_progress/all_chatrooms.dart';
import 'package:proj/ChatApp/pages/chatrooms/all_group_page.dart';
import 'package:proj/ChatApp/pages/chatrooms/chat_page.dart';
import 'package:proj/ChatApp/pages/profiles/complete_profile.dart';
import 'package:proj/ChatApp/pages/adding_people/group_chats.dart';
import 'package:proj/ChatApp/pages/authenticate/login.dart';
import 'package:proj/ChatApp/pages/for_media/send_media.dart';
import 'package:proj/ChatApp/pages/screenTime.dart';
import 'package:proj/ChatApp/pages/story/story.dart';
import 'package:proj/ChatApp/pages/for_media/view_media.dart';

// viewing media before sending
class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser; // firebase auth user
  const HomePage(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static Widget? currentScreenBoth;
  List<Widget> screensList = [];
  String? capturedFile;

  @override
  void initState() {
    currentScreenBoth = ChatPage(
        firebaseUser: widget.firebaseUser, userModel: widget.userModel);

    screensList = [
      ChatPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel),
      Stories(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
      AllGroupChatPage(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      )
    ];
    super.initState();
  }

  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                await fromCamera("picture");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewMedia(
                            mediaToSend: capturedFile!,
                            usermodel: widget.userModel,
                            type: "image", 
                            firebaseUser: widget.firebaseUser,)));
              },
              icon: Icon(Icons.camera_alt_outlined)),
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (BuildContext context) => [
              //1
              PopupMenuItem(
                child: const ListTile(
                  title: Text("Log Out",
                      style: TextStyle(fontFamily: "EuclidCircularB")),
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
                  title: Text("View profile",
                      style: TextStyle(fontFamily: "EuclidCircularB")),
                  leading: Icon(Icons.person),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompleteUserProfile(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              )));
                },
              ),

              //3
              PopupMenuItem(
                child: const ListTile(
                  title: Text("create a group",
                      style: TextStyle(fontFamily: "EuclidCircularB")),
                  leading: Icon(Icons.group_add),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupChatPage(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              )));
                },
              ),

            //  4
            
              PopupMenuItem(
                child: const ListTile(
                  title: Text("Activity",
                      style: TextStyle(fontFamily: "EuclidCircularB")),
                  leading: Icon(Icons.timeline),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Screentime(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              )));
                },
              ),
            ],
          )
        ],
        // backgroundColor: const Color.fromARGB(255, 158, 219, 241),
        automaticallyImplyLeading: false,

        title: const Text("Chat App",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontFamily: "EuclidCircularB")),
      ),
      body: currentScreenBoth, // body of sdcaffold

      //////////////
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: myIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myIndex = index;
            currentScreenBoth = screensList[myIndex];
          });
        },
        selectedItemColor: Colors.black,
        items: const [
          // home
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chats"),

          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Status",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
        ],
      ),
    );
  }

  // image from camera
  Future fromCamera(String cameraType) async {
    late final captured;
    captured = await ImagePicker().pickImage(source: ImageSource.camera);

    if (captured != null) {
      setState(() {
        capturedFile = captured.path;
      });
    }
  }
}
