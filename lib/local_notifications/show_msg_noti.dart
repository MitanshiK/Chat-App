import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/local_notifications/notif.dart';
import 'package:proj/main.dart';

class ShowMsgNotif {
  User? currentUser;
  UserModel? userModel;
  // static const  ="";

  Future getUsers() async{
   currentUser = FirebaseAuth.instance.currentUser; // get current user of the chat app
   userModel = await FirebaseHelper.getUserModelById(currentUser!.uid); // getting data of user using userId
}



}