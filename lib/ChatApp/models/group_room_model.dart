import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRoomModel {
  String? groupName;
  String? profilePic;
  String? groupRoomId;
  Map<String,dynamic>? participantsId; //id of 2 participants of the chatroom
  String? lastMessage;
  DateTime? lastTime;
  String? lastMessageBy;
  String? createdBy;

  GroupRoomModel({this.groupName,this.profilePic,  this.groupRoomId, this.participantsId,this.lastMessage ,this.lastMessageBy,this.createdBy,this.lastTime});

  GroupRoomModel.fromMap(Map<String, dynamic> mapData) {
    groupName = mapData["groupName"];
    profilePic = mapData["profilePic"];
    groupRoomId = mapData["groupRoomId"];
    participantsId = mapData["participantsId"];
      lastMessage = mapData["lastMessage"];
      lastMessageBy = mapData["lastMessageBy"];
      createdBy = mapData["createdBy"];
       lastTime = (mapData["lastTime"] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
    "groupName": groupName, 
    "profilePic": profilePic, 
    "groupRoomId": groupRoomId, 
    "participantsId": participantsId,
     "lastMessage": lastMessage,
     "lastMessageBy": lastMessageBy,
      "lastTime": lastTime,
      "createdBy": createdBy
    };
    
  }
}
