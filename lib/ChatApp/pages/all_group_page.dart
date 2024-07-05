import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/firebase_helper.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/group_chats.dart';
import 'package:proj/ChatApp/pages/groupchatroom.dart';

class AllGroupChatPage extends StatefulWidget {
   AllGroupChatPage({super.key , required this.firebaseUser, required this.userModel });
   final UserModel userModel;
  final User firebaseUser; // firebase auth user

  @override
  State<AllGroupChatPage> createState() => _AllGroupChatPageState();
}

class _AllGroupChatPageState extends State<AllGroupChatPage> {
List<UserModel> groupMembers =[];   


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("group chats"),),
      body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("GroupChats")
                .where("participantsId.${widget.userModel.uId}", isEqualTo: true)
                .snapshots(), // get the chatroom that contain current User
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
      
                  return (dataSnapshot.docs.isNotEmpty) 
                  ? ListView.builder(
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      GroupRoomModel groupRoomModel = GroupRoomModel.fromMap(
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>);


                     // to get targetUsers Id
                      Map<String, dynamic> participants =
                          groupRoomModel.participantsId!; // getting participants
                      List<String> participantsList = participants.keys
                          .toList(); // getting participants keys and saving in list
                      participantsList.remove(widget.userModel
                          .uId);  // removing currentUser key so that we are left with targetuser id
             
                                  // getMembersModel(participantsList);   // to get list of usermodels of members
                              getMembersModel(participantsList);

        //  UserModel lastMessageUser=UserModel();  

        //   FirebaseFirestore.instance.collection("ChatAppUsers")
        //  .doc(groupRoomModel.lastMessageBy).get().then((value) async{

        //             lastMessageUser= await UserModel.fromMap(value.data() as Map<String,dynamic>);
        //       });

    

                              
                              String toShow;
                              String msgDate="${groupRoomModel.lastTime!.day}/${groupRoomModel.lastTime!.month}/${groupRoomModel.lastTime!.year}";
                              String currentDate="${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                               
                            
                              //  for(var id in groupMembers){
                              //   if(groupRoomModel.lastMessageBy==id.uId){
                              //       lastMessageUser=id;
                              //    }
                              //  }
                               
                              //  print("the last message was by ${lastMessageUser.name}");
                       
                               if(currentDate.compareTo(msgDate)==0){
        
                                String msgTime="${groupRoomModel.lastTime!.hour}:${groupRoomModel.lastTime!.minute}";
                                String curTime="${DateTime.now().hour}:${DateTime.now().minute}";
      
                                // inner if start
                                if(msgTime==curTime){
                                  toShow="now";
                                }
                                else{
                                  toShow=msgTime;
                                }// inner if close
      
                               }else{
                                toShow = msgDate;
                               }
                              return StreamBuilder(
                                stream:  FirebaseFirestore.instance
                                          .collection("ChatAppUsers")
                                          .where("uId", isEqualTo: groupRoomModel.lastMessageBy)
                                           .snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                
                                   if (snapshot.hasData){   
                                       QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                                if(dataSnapshot.docs.length>0){
                                UserModel lastMessageUser = UserModel.fromMap(
                                               dataSnapshot.docs[0].data()
                                            as Map<String, dynamic>);

                                 // UserModel lastMessageUser=  UserModel.fromMap(dataSnapshot.docs[0].data() as Map<String,dynamic>);

                                  return  ListTile(
                                  onTap: () async{
                                   await    getMembersModel(participantsList); 
                                     // to get list of usermodels of members
                                      print("members are ${groupMembers.toString()}");
                                
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupRoomPage(
                                                  firebaseUser: widget.firebaseUser,
                                                  userModel: widget.userModel,
                                                  groupRoomModel: groupRoomModel,
                                                   groupMembers:groupMembers,
                                                )));
                                  },
                                  title: Text(groupRoomModel.groupName.toString()),
                                  leading: CircleAvatar(
                                     radius: 25,
                                    backgroundColor:
                                        const Color.fromARGB(255, 158, 219, 241),
                                    backgroundImage: NetworkImage(
                                       groupRoomModel.profilePic.toString()),
                                  ),
                                  subtitle: (groupRoomModel.lastMessage.toString() !=
                                          "")
                                      ? Text((lastMessageUser.uId==widget.userModel.uId)
                                          ? "You : ${groupRoomModel.lastMessage.toString()}"
                                          :  "${lastMessageUser.name} : ${groupRoomModel.lastMessage.toString()}"
                                          )
                                      : const Text("Say Hello"),
                                      trailing: Text(toShow),
                                );
                             } else{
                              return ListTile(
                                  onTap: () async{
                                   await    getMembersModel(participantsList); 
                                     // to get list of usermodels of members
                                      print("members are ${groupMembers.toString()}");
                                
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupRoomPage(
                                                  firebaseUser: widget.firebaseUser,
                                                  userModel: widget.userModel,
                                                  groupRoomModel: groupRoomModel,
                                                   groupMembers:groupMembers,
                                                )));
                                  },
                                  title: Text(groupRoomModel.groupName.toString()),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        const Color.fromARGB(255, 158, 219, 241),
                                    backgroundImage: NetworkImage(
                                       groupRoomModel.profilePic.toString()),
                                  ),
                                  subtitle: (groupRoomModel.lastMessage.toString() !=
                                          "")
                                      ? const Text(("say hello")
                                          
                                          )
                                      : const Text("Say Hello"),
                                      trailing: Text(toShow),
                                );
                             }
                                }else{
                                  return const Text("no data");
                                }
                                
                                }
                              );
                    },
                  )
                  :GroupChatPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser,);
      
                  /////
                } else if (snapshot.hasError) {
                  return GroupChatPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser,);
                } else {
                  return  GroupChatPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser,);
                }
              } else {
                return const Center(
                   child: CircularProgressIndicator(),
                );
              }
            },
          ),
         ),
    );

  }

  // getting usersmodel from uid and adding to members list
Future getMembersModel(List<String> UIds)async{

  List<UserModel> fungroupMembers =[]; 
  for(var id in UIds){
     UserModel? a= await FirebaseHelper.getUserModelById(id);
     fungroupMembers.add(a!);
   }

  groupMembers.clear(); 
 groupMembers.addAll(fungroupMembers);
 groupMembers.add(widget.userModel);

}

}