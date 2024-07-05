import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/create_group.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key , required this.firebaseUser, required this.userModel});
   final UserModel userModel;
  final User firebaseUser;

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.sizeOf(context).width,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200 ,maxWidth: 200),
          child: Image.asset("assets/focus-group.png")),
          const SizedBox(height: 60,),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 239, 125, 116))
                          ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> 
                      CreateGroupPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel, existing: false,)));
                  },
                  child: const Text(
                    "Create a GroupChat",
                    style: TextStyle(color: Colors.black),

                  ))
            ],
          ) 
         ),
    );
  }
}