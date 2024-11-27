import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/chatrooms/all_group_page.dart';
import 'package:proj/ChatApp/pages/profiles/create_group_profile.dart';
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
  List<UserModel> groupMembers = [];
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
    var data = doc.data();
    var participantIds = data['participantsId'] as Map<String, dynamic>;
    return groupMembers.every((user) => participantIds.containsKey(user.uId));
  }).toList();


  if (matchingChatRooms.isNotEmpty) {
    // Fetch existing chat room
    var docData = matchingChatRooms[0].data();
    groupRoomModel = GroupRoomModel.fromMap(docData);
    debugPrint("Chatroom already exists: ${groupRoomModel.groupRoomId}");
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
    debugPrint("New chatroom created: ${groupRoomModel.groupRoomId}");
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
    var data = doc.data();
    var participantIds = data['participantsId'] as Map<String, dynamic>;
    return  widget.exisitingMembers!.every((user) => participantIds.containsKey(user.uId));
  }).toList();


  if (matchingChatRooms.isNotEmpty) {
    // Fetch existing chat room
    var docData = matchingChatRooms[0].data();
    groupRoomModel = GroupRoomModel.fromMap(docData);
    debugPrint("Chatroom already exists: ${groupRoomModel.groupRoomId}");
    } 

///////////////////////////
    debugPrint("Participant added successfully.");
  } catch (e) {
    debugPrint("Error adding participant: $e");
  }
}


///////////////////////////

  @override
  void initState() {
    
    if(widget.existing==false){
    groupMembers.add(widget.userModel);
     } // adding ourselves to the group
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Search people to add "  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
         Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
              
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color:  const Color.fromARGB(255, 249, 233, 233),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6,left: 6),
                            child: const Icon(Icons.search)
                          ),
                        ),
                        Expanded(
                          child: TextField(
                           autofocus: false,
                           controller: searchFieldController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: "Search Friends to add to group",
                                suffix: GestureDetector(
                                  onTap: (){
                                    searchFieldController.clear();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    child: const Visibility(
                                      visible: true,
                                      child:Icon(Icons.close)
                                    ),
                                  ),
                                ),
                                
                                ),
                              
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: 
                   const Text("cancel", ),
                )
              ],
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

                      if (dataSnapshot.docs.isNotEmpty) {
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
                                if(groupMembers.contains(searchData)==false){
                                groupMembers.add(searchData);
                                }
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
                          title: Text(searchData.name.toString() ,style: const TextStyle(fontFamily:"EuclidCircularB")  ),
                          subtitle: Text(searchData.email.toString()  ,style: const TextStyle(fontFamily:"EuclidCircularB")  ),
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
                        return const Text("No result Found"  ,style: TextStyle(fontFamily:"EuclidCircularB")  );
                      }
                    } else if (snapshot.hasError) {
                      return const Text("An error has occured" ,style: TextStyle(fontFamily:"EuclidCircularB")  );
                    } else {
                      return const Text("No result found"  ,style: TextStyle(fontFamily:"EuclidCircularB")  );
                    }
                  } else {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 50
                      ),
                    child: const CircularProgressIndicator());
                  }
                }),
          ),

          /////////////////
          (groupMembers.isEmpty)
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
                    itemCount: groupMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                (groupMembers[index].profileUrl == null)
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            groupMembers[index].profileUrl!),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(groupMembers[index].name!  ,style: const TextStyle(fontFamily:"EuclidCircularB")  )
                              ],
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: -1,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      groupMembers.removeAt(index);
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
                  WidgetStatePropertyAll(Color.fromARGB(255, 239, 125, 116))),
          onPressed: () async{
            // if we are creating a new group
                            if(widget.existing==false){
                              GroupRoomModel? groupRoomModel;
                              if(groupMembers.length>=3){
                             groupRoomModel=await getGroupRoomModel(groupMembers); // getting grouproom model from function   
                              }
                              else{
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text("a group should contain atleast 3 members")));
                              }
                              if(groupRoomModel!=null){
                                debugPrint("groupChat created");
                                 
                               if(groupMembers.length>=3){
                               
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AllGroupChatPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel)));
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateGroupProfile(
                                  firebaseUser: widget.firebaseUser,
                                   userModel: widget.userModel,
                                    groupRoomModel:groupRoomModel! , 
                                    groupMembers: groupMembers,)));
                               }

                              }
                       } // existing false

                       if(widget.existing==true){
                       addMemberToExisting(groupMembers);
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
    flag=0;
    if (groupMembers.isNotEmpty) {
      for (var i in groupMembers) {
        if (i.email==searchData.email) {
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
