 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class MediaModel{
 String? mediaId;
 String? senderId;
 String? fileUrl;
 DateTime? createdOn;
 String? type;

 MediaModel({this.mediaId,this.senderId,this.createdOn,this.fileUrl,this.type});

  MediaModel.fromMap(Map<String,dynamic> mapData){
  mediaId=mapData["mediaId"];
  senderId=mapData["senderId"];
    fileUrl=mapData["fileUrl"];
  createdOn=(mapData["createdOn"] as Timestamp).toDate(); // to remove "timestamp not subtype of dateTime" error
  type=mapData["type"];
   }

 Map<String,dynamic> toMap(){
  return{
  "mediaId":mediaId,
   "senderId" :senderId,
  "fileUrl" :fileUrl,
  "createdOn":createdOn,
   "type":type
  };
 }

 }