import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/show_selected_contact.dart';

class ReadContacts extends StatefulWidget {
 ReadContacts({super.key , this.chatRoomModel ,required this.userModel ,this.groupRoomModel});
  final ChatRoomModel? chatRoomModel;
  final GroupRoomModel? groupRoomModel;
  final UserModel userModel;


  @override
  State<ReadContacts> createState() => _ReadContactsState();
}

class _ReadContactsState extends State<ReadContacts> {
 List<Contact> contactsList=[];  // fetched contact's data will be stored in this list
List<Contact> shareContactList=[];

void getPhoneData() async {
    if (await FlutterContacts.requestPermission()) {
      contactsList = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
         
        
    }
    setState(() {});
  }

@override
  void initState() {
    getPhoneData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Contacts" ,style: TextStyle(fontFamily:"EuclidCircularB")),
      actions: [
        // Done Button
            TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  if(widget.chatRoomModel!=null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => 
                          ShowSelectedContacts(
                                shareContactList: shareContactList,
                                chatRoomModel: widget.chatRoomModel, userModel: widget.userModel,
                              )));
                  }
                  else if(widget.groupRoomModel!=null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => 
                          ShowSelectedContacts(
                                shareContactList: shareContactList,
                                groupRoomModel: widget.groupRoomModel, userModel: widget.userModel,
                              )));
                  }
                },
                child: const Text("Done" ,style: TextStyle(fontFamily:"EuclidCircularB")))
          ],
          backgroundColor: const Color.fromARGB(255, 113, 210, 246),
      centerTitle: true,),
      
      body: contactsList==[]
      ? const Center(child: CircularProgressIndicator(),)
      : 
      Container(
        child: Column(
          children: [
             // to show all contacts
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (BuildContext context, int index) { 
                
                 Uint8List? ContactImage = contactsList[index].photo;
                          // String num = (contactsList[index].phones.isNotEmpty)
                          //     ? (contactsList[index].phones.first.number)
                          //     : "--";
                
                    return ListTile(
                      onTap: (){
                        setState(() {
                        shareContactList.add(contactsList[index]) ;    // adding selected contact to list 
                        });
                      },
                      leading: (contactsList[index].photo==null) 
                              ? const CircleAvatar(backgroundColor: Colors.blue ,child: Icon(Icons.person ,color: Colors.white,),)
                              :CircleAvatar(backgroundImage: MemoryImage(ContactImage!),),
                              title: Text(contactsList[index].name.first ,style: TextStyle(fontFamily:"EuclidCircularB")),
                      subtitle: Text(contactsList[index].phones.first.number ,style: TextStyle(fontFamily:"EuclidCircularB")), 
                    );
                   },),
              ),
            ),

             //   to show selected contacts
            shareContactList.length==0 
            ? const SizedBox()
           :  Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 222, 220, 220),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
            padding: const EdgeInsets.all(10),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height/8,
              child:  
           ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: shareContactList.length,
              itemBuilder: (BuildContext context, int index) { 
        
              Uint8List? SelectedContactImage = shareContactList[index].photo;
                  
        
                return Stack(
                  children: [
                   
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(children: [
                        (shareContactList[index].photo==null) 
                                ? const CircleAvatar(backgroundColor: Colors.blue ,child: Icon(Icons.person ,color: Colors.white,),)
                                : CircleAvatar(backgroundImage: MemoryImage(SelectedContactImage!),),
                                const SizedBox(height: 5,),
                               Text(shareContactList[index].name.first ,style: TextStyle(fontFamily:"EuclidCircularB"))
                      ],),
                    ),
                     Positioned(right: 0,
                    top: -1,
                      child:GestureDetector(
                        onTap: (){
                          setState(() {
                            shareContactList.removeAt(index);
                          });
                          
                        },
                        child: const Icon(Icons.cancel ,color: Colors.white,))),
                  ],
                );
        
             },),
            )
          ],
        ),
      )
    );
  }
}