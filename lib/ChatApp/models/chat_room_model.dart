import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomId;
  Map<String,dynamic>? participantsId; //id of 2 participants of the chatroom
  String? lastMessage;
  DateTime? lastTime;

  ChatRoomModel({this.chatRoomId, this.participantsId,this.lastMessage,this.lastTime});

  ChatRoomModel.fromMap(Map<String, dynamic> mapData) {
    chatRoomId = mapData["chatRoomId"];
    participantsId = mapData["participantsId"];
      lastMessage = mapData["lastMessage"];
       lastTime = (mapData["lastTime"] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
    "chatRoomId": chatRoomId, 
    "participantsId": participantsId,
     "lastMessage": lastMessage,
      "lastTime": lastTime
     
    };
    
  }
}
