import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/adding_people/create_group.dart';

class NoGroupChatPage extends StatefulWidget {
  const NoGroupChatPage({super.key , required this.firebaseUser, required this.userModel});
   final UserModel userModel;
  final User firebaseUser;

  @override
  State<NoGroupChatPage> createState() => _NoGroupChatPageState();
}

class _NoGroupChatPageState extends State<NoGroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ConstrainedBox(
            constraints:  BoxConstraints(maxHeight: MediaQuery.sizeOf(context).width/2 ,maxWidth: MediaQuery.sizeOf(context).width/2),
          child: Image.asset("assets/focus-group.png")),
          const SizedBox(height: 60,),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                         Color.fromARGB(255, 247, 155, 148))
                          ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> 
                      CreateGroupPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel, existing: false,)));
                  },
                  child: const Text(
                    "Create a GroupChat",
                    style: TextStyle(
                       fontFamily:"EuclidCircularB",  
                      color: Colors.black),

                  ))
            ],
          ) 
         ),
    );
  }
}