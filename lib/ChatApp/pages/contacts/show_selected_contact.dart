import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/contacts_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/main.dart';

class ShowSelectedContacts extends StatefulWidget {
  const ShowSelectedContacts({super.key ,required this.shareContactList , this.chatRoomModel,this.groupRoomModel ,required this.userModel});
 final List<Contact> shareContactList;
 final ChatRoomModel? chatRoomModel;
 final GroupRoomModel? groupRoomModel;
 final UserModel userModel;

  @override
  State<ShowSelectedContacts> createState() => _ShowSelectedContactsState();
}

class _ShowSelectedContactsState extends State<ShowSelectedContacts> {
@override
  void initState() {
    if(widget.shareContactList.isEmpty){
      setState(() {
        Navigator.pop(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Contacts" ,style: TextStyle(fontFamily:"EuclidCircularB")),
      centerTitle: true,),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: widget.shareContactList.length,
          itemBuilder: (BuildContext context, int index) {

           Uint8List? selectedContactImage = widget.shareContactList[index].photo;
           
            return  Column(
              children:<Widget> [
                Row(children: [
                   (widget.shareContactList[index].photo==null) 
                                ? const CircleAvatar( radius: 30, backgroundColor: Colors.blue ,child: Icon(Icons.person ,color: Colors.white,),)
                                : CircleAvatar(radius: 30, backgroundImage: MemoryImage(selectedContactImage!),),
                       
                 const SizedBox(width: 20,),
                 Text(widget.shareContactList[index].displayName ,style: const TextStyle(fontFamily:"EuclidCircularB"))
                ],),
               
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15),
                  leading: const Icon(Icons.phone ,color: Colors.blue,),
                  title: Text(widget.shareContactList[index].phones.first.number ,style: const TextStyle(fontFamily:"EuclidCircularB")),
                  subtitle: const Text("Phone" ,style: TextStyle(fontFamily:"EuclidCircularB")),
                  trailing: IconButton(onPressed: (){
                    setState(() {
                       widget.shareContactList.removeAt(index); 
                        if(widget.shareContactList.isEmpty){
                        Navigator.pop(context);
                        }
                    });
                      
                  }, icon: const Icon(Icons.cancel)),
                ),
                const Divider(
                  thickness: 2,
                )
              ],
            );
            },),),
            floatingActionButton:IconButton(
              onPressed: () async{
                int length= widget.shareContactList.length;
                // send contacts one by one 
                for(var i in widget.shareContactList){
                  sendContact(i);
                  length--;
                }
                // when all the contacts are sent then pop out of the page
                if(length==0){
                     Navigator.pop(context);
                }
            }, icon: const Icon(
              Icons.send ,size: 40,color: Colors.blue,))
    );
  }
  Future sendContact(Contact contact)async{
     
        ContactModal contactModel = ContactModal(
          contactId :uuid.v1(),
           senderId :widget.userModel.uId,
            createdOn:DateTime.now(),
            phone :contact.phones.first.number ,
             name:contact.displayName
        );

        if(widget.chatRoomModel!=null){
          // creating a messages collection inside chatroom docs and saving messages in them
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomModel!.chatRoomId)
            .collection("messages")
            .doc(contactModel.contactId)
            .set(contactModel.toMap())
            .then((value) {
          debugPrint("message sent");
        });

        // setting last message in chatroom and saving in firestore
        widget.chatRoomModel!.lastMessage = "contact";
           widget.chatRoomModel!.lastTime=contactModel.createdOn;  
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomModel!.chatRoomId)
            .set(widget.chatRoomModel!.toMap());
            }

            else if(widget.groupRoomModel!=null){
          // creating a messages collection inside chatroom docs and saving messages in them
        FirebaseFirestore.instance
            .collection("GroupChats")
            .doc(widget.groupRoomModel!.groupRoomId)
            .collection("messages")
            .doc(contactModel.contactId)
            .set(contactModel.toMap())
            .then((value) {
          debugPrint("message sent");
        });

        // setting last message in chatroom and saving in firestore
        widget.groupRoomModel!.lastMessage = "contact";
           widget.groupRoomModel!.lastTime=contactModel.createdOn;  
           widget.groupRoomModel!.lastTime=contactModel.createdOn;
        FirebaseFirestore.instance
            .collection("GroupChats")
            .doc(widget.groupRoomModel!.groupRoomId)
            .set(widget.groupRoomModel!.toMap());
            }
    
        
          
  }
}