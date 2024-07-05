import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModal{
   ContactModal({ this.contactId, this.senderId,this.createdOn, this.phone,this.name});
String? contactId;
 String? senderId;
 String? phone;
 String? name;
 DateTime? createdOn;
 String type ="contact";

  ContactModal.fromMap(Map<String,dynamic> mapData){
  contactId=mapData["contactId"];
  senderId=mapData["senderId"];
    phone=mapData["phone"];
    name=mapData["name"];
  createdOn=(mapData["createdOn"] as Timestamp).toDate(); // to remove "timestamp not subtype of dateTime" error
  type=mapData["type"];
   }

 Map<String,dynamic> toMap(){
  return{
  "contactId":contactId,
   "senderId" :senderId,
  "phone" :phone,
  "name" :name,
  "createdOn":createdOn,
   "type":type
  };
 }

}