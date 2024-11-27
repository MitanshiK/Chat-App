
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj/ChatApp/helpers/firebase_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';

class ShowMsgNotif {
  User? currentUser;
  UserModel? userModel;
  // static const  ="";

  Future getUsers() async{
   currentUser = FirebaseAuth.instance.currentUser; // get current user of the chat app
   userModel = await FirebaseHelper.getUserModelById(currentUser!.uid); // getting data of user using userId
}



}