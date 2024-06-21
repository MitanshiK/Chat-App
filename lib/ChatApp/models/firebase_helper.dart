
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proj/ChatApp/models/user_model.dart';
// used to get the userdata from firebase by user Uid in the form of usermodel

class FirebaseHelper{
 
static Future<UserModel?> getUserModelById(String uid ) async{
  UserModel? userModel;

  final result = await FirebaseFirestore.instance.collection("ChatAppUsers").doc(uid).get();

  if(result.data()!=null)
  {
    userModel=await UserModel.fromMap(result.data() as Map<String,dynamic>);
  }

  return userModel;
 }


}