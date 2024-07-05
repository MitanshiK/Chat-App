import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
 String? messageId;
 String? senderId;
 String? text;
 bool? seen;
 DateTime? createdOn ;
 String? type;     // type of data eg text , image ,video etc
//  PlatformFile? files;

 MessageModel({this.messageId,this.senderId,this.text,this.seen, this.createdOn
 ,this.type
 });

 MessageModel.fromMap(Map<String,dynamic> mapData){
  messageId=mapData["messageId"];
  senderId=mapData["senderId"];
  text=mapData["text"];
  seen=mapData["seen"];
  createdOn=(mapData["createdOn"] as Timestamp).toDate(); // to remove "timestamp not subtype of dateTime" error
  type=mapData["type"];
 }

 Map<String,dynamic> toMap(){

  return{
  "messageId":messageId,
  "senderId" :senderId,
  "text":text,
  "seen":seen,
  "createdOn":createdOn,
  "type":type
  };
 }

}