import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/all_group_page.dart';
import 'package:proj/ChatApp/pages/create_group_profile.dart';
import 'package:proj/ChatApp/pages/group_chats.dart';
import 'package:proj/main.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage(
      {super.key, required this.firebaseUser, required this.userModel ,required this.existing ,this.exisitingGroupRoom ,this.exisitingMembers});
  final User firebaseUser;
  final UserModel userModel;
  final bool existing;
  final GroupRoomModel? exisitingGroupRoom;
  final List<UserModel>? exisitingMembers;


  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController searchFieldController = TextEditingController();
  List<UserModel> GroupMembers = [];
  int flag = 0;
    Map<String, dynamic>? map1;

Future<GroupRoomModel?> getGroupRoomModel(List<UserModel> groupMembers) async {
  GroupRoomModel? groupRoomModel;
  Map<String, bool> participantsId = {};

  // Initialize participants map
  for (var member in groupMembers) {
    participantsId[member.uId!] = true;
  }

  // Firestore query to check if chatroom exists
  var chatRoomQuery = FirebaseFirestore.instance
      .collection("GroupChats")
      .where("participantsId", arrayContainsAny: groupMembers.map((e) => e.uId).toList());

  var querySnapshot = await chatRoomQuery.get();

  

  var matchingChatRooms = querySnapshot.docs.where((doc) {
    var data = doc.data() as Map<String, dynamic>;
    var participantIds = data['participantsId'] as Map<String, dynamic>;
    return groupMembers.every((user) => participantIds.containsKey(user.uId));
  }).toList();


  if (matchingChatRooms.isNotEmpty) {
    // Fetch existing chat room
    var docData = matchingChatRooms[0].data() as Map<String, dynamic>;
    groupRoomModel = GroupRoomModel.fromMap(docData);
    print("Chatroom already exists: ${groupRoomModel.groupRoomId}");
    } 
    else {
    // Create new chat room
    GroupRoomModel newGroupRoomModel = GroupRoomModel(
      groupRoomId: uuid.v1(),
      groupName:"",
      profilePic:"",
      lastMessage: "",
      participantsId: participantsId,
      lastMessageBy: "",
      lastTime: DateTime.now(),
      createdBy: widget.userModel.uId
    );

    await FirebaseFirestore.instance
        .collection("GroupChats")
        .doc(newGroupRoomModel.groupRoomId)
        .set(newGroupRoomModel.toMap());

    groupRoomModel = newGroupRoomModel;
    print("New chatroom created: ${groupRoomModel.groupRoomId}");
  }

  return groupRoomModel;
}
//////existing true
Future addMemberToExisting(List<UserModel> newMemberss)async{
  try {
    // Reference to the specific group chat document
    DocumentReference groupChatRef = FirebaseFirestore.instance.collection("GroupChats").doc(widget.exisitingGroupRoom!.groupRoomId);

    // Update the participantsId field by adding the new participant
  for(var newMember in newMemberss){  
    await groupChatRef.update({
      "participantsId.${newMember.uId}": true
    });
    }
////////////////////////////

  widget.exisitingMembers!.addAll(newMemberss);
  GroupRoomModel? groupRoomModel;
  Map<String, bool> participantsId = {};

  for (var member in widget.exisitingMembers!) {
    participantsId[member.uId!] = true;
  }

  // Firestore query to check if chatroom exists
  var chatRoomQuery = FirebaseFirestore.instance
      .collection("GroupChats")
      .where("participantsId", arrayContainsAny: widget.exisitingMembers!.map((e) => e.uId).toList());

  var querySnapshot = await chatRoomQuery.get();

  

  var matchingChatRooms = querySnapshot.docs.where((doc) {
    var data = doc.data() as Map<String, dynamic>;
    var participantIds = data['participantsId'] as Map<String, dynamic>;
    return  widget.exisitingMembers!.every((user) => participantIds.containsKey(user.uId));
  }).toList();


  if (matchingChatRooms.isNotEmpty) {
    // Fetch existing chat room
    var docData = matchingChatRooms[0].data() as Map<String, dynamic>;
    groupRoomModel = GroupRoomModel.fromMap(docData);
    print("Chatroom already exists: ${groupRoomModel.groupRoomId}");
    } 

///////////////////////////
    print("Participant added successfully.");
  } catch (e) {
    print("Error adding participant: $e");
  }
}


///////////////////////////

  @override
  void initState() {
    
    if(widget.existing==false){
    GroupMembers.add(widget.userModel);
     } // adding ourselves to the group
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search people to add "),
        backgroundColor: const Color.fromARGB(255, 239, 125, 116),
      ),
      body: Column(
        children: [
          ListTile(
            title: TextField(
              controller: searchFieldController,
              decoration: const InputDecoration(
                hintText: "Search",
              ),
            ),
            // Button
            trailing: IconButton(
              onPressed: () {
                setState(() {}); // to refresh
              },
              icon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .where("email", isEqualTo: searchFieldController.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data
                          as QuerySnapshot; // convert into type QuerySnapshot

                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userDataMap =
                            dataSnapshot.docs[0].data() as Map<String,
                                dynamic>; // convertig document data into map

                        UserModel searchData = UserModel.fromMap(
                            userDataMap); //  saving data of searched user in usermodel to usermodel

                        return ListTile(
                          onTap: () async {
                            await checkMembers(searchData);
                            debugPrint(" flag in button $flag");

                            //
                            if (flag == 0) {
                              setState(() {
                                GroupMembers.add(searchData);
                              });
                            }
                            
                            // GroupRoomModel? groupRoomModel=await getGroupRoomModel(searchData);

                            // if(groupRoomModel!=null){
                            //   Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ChatRoomPage(
                            //               firebaseUser: widget.firebaseUser,
                            //               userModel: widget.userModel,
                            //               targetUser: searchData,
                            //               groupRoomModel: groupRoomModel,
                            //             )));
                            //             }
                          },
                          title: Text(searchData.name.toString()),
                          subtitle: Text(searchData.email.toString()),
                          leading: CircleAvatar(
                              backgroundImage: (searchData.profileUrl != null)
                                  ? NetworkImage(
                                      searchData.profileUrl.toString())
                                  : null,
                              backgroundColor:
                                  const Color.fromARGB(255, 239, 125, 116),
                              child: (searchData.profileUrl == null)
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    )
                                  : null),
                        );
                      } else {
                        return const Text("No result Found");
                      }
                    } else if (snapshot.hasError) {
                      return const Text("An error has occured");
                    } else {
                      return const Text("No result found");
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),

          /////////////////
          (GroupMembers.length == 0)
              ? const SizedBox()
              : Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 222, 220, 220),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 8,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: GroupMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                (GroupMembers[index].profileUrl == null)
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            GroupMembers[index].profileUrl!),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(GroupMembers[index].name!)
                              ],
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: -1,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      GroupMembers.removeAt(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ))),
                        ],
                      );
                    },
                  ),
                )
        ],
      ),
      floatingActionButton: IconButton(
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 239, 125, 116))),
          onPressed: () async{
            // if we are creating a new group
                            if(widget.existing==false){
                            GroupRoomModel? groupRoomModel=await getGroupRoomModel(GroupMembers); // getting grouproom model from function   
                              if(groupRoomModel!=null){
                                debugPrint("groupChat created");
                                 
                               if(GroupMembers.length>=3){
                               
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AllGroupChatPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel)));
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateGroupProfile(
                                  firebaseUser: widget.firebaseUser,
                                   userModel: widget.userModel,
                                    groupRoomModel:groupRoomModel , 
                                    groupMembers: GroupMembers,)));
                               }

                              }
                       } // existing false

                       if(widget.existing==true){
                       addMemberToExisting(GroupMembers);
                        Navigator.popUntil(context, (route) => route.isFirst);
                        // Navigator.push(context, MaterialPageRoute(builder: ((context) => )));
                      
                       }
          },
          icon: const Icon(
            Icons.done,
            color: Colors.white,
          )),
    );
  }

  ////
  Future checkMembers(UserModel searchData) async {
    if (GroupMembers.isNotEmpty) {
      for (var i in GroupMembers) {
        if (i == searchData) {
          setState(() {
            flag = 1;
          });
          debugPrint(" flag in fun $flag");
        }
      }
      debugPrint(" flag in fun $flag");
    }
  }
}
