import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/create_group.dart';
import 'package:proj/ChatApp/pages/create_group_profile.dart';
import 'package:proj/ChatApp/pages/open_media.dart';
import 'package:video_player/video_player.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo(
      {super.key,
      required this.firebaseUser,
      required this.userModel,
      required this.groupMembers,
      required this.groupRoomModel});

  final User firebaseUser; // <us> or current user on our side
  final UserModel userModel; // <us> our info

  final List<UserModel> groupMembers; // <other> person we are talking to
  final GroupRoomModel groupRoomModel;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  String? messageType;
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  title:
          //       Text(widget.targetUser.name.toString())
          ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 85,
                  backgroundColor: const Color.fromARGB(255, 240, 217, 148),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: const Color.fromARGB(255, 240, 217, 148),
                    backgroundImage: NetworkImage(widget.groupRoomModel.profilePic!),
                  ),
                ),
                  Positioned(        
                     right: 5,
                     bottom: 5,
                     child:IconButton(
                      padding: EdgeInsets.zero,
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 240, 217, 148))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateGroupProfile(
                                        firebaseUser: widget.firebaseUser, userModel: widget.userModel, groupRoomModel: widget.groupRoomModel, groupMembers: widget.groupMembers,
                                      )));
                        },
                        icon: const Icon(
                          Icons.mode_edit_rounded,
                          size: 25,
                        )))
              ],
            ),
          ),
          // profile img
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  widget.groupRoomModel.groupName!,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.groupMembers.length} Members",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Divider(
            thickness: 5,
            color: Color.fromARGB(255, 240, 217, 148),
          ),

          //media
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(children: [
              Text(
                "Shared videos and images",
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
              )
            ]),
          ),
////////////////////////////////////////
          StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("GroupChats")
                    .doc(widget.groupRoomModel.groupRoomId)
                    .collection("messages")
                    .orderBy("createdOn",
                        descending:
                            false) // so that messages appear from newer to older
                    .snapshots(), // to convert into streams

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data
                          as QuerySnapshot; // converting into QuerySnapshot dataType

                           late MediaModel currentMedia=MediaModel();

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight:  220,
                          maxWidth: MediaQuery.sizeOf(context).width/2,
                          ),
                        child:  (dataSnapshot.docs.isNotEmpty) ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var dt = dataSnapshot.docs[index].data() as Map< String,dynamic>; // map of data at particular index
                        
                         if (dt.containsValue("image") == true || dt.containsValue("video") == true) {
                              currentMedia = MediaModel.fromMap(
                                  dataSnapshot.docs[index].data()
                                      as Map<String, dynamic>);
                                      
                              if (dt.containsValue("image") == true) {
                                messageType = "image";
                              } else if (dt.containsValue("video") == true) {
                                videoController = VideoPlayerController.networkUrl(Uri.parse(currentMedia.fileUrl!));
                                _initializeVideoPlayerFuture =videoController!.initialize();
                                messageType = "video";
                              } 
                            }
                        
                            return   Container(
                              padding: const EdgeInsets.all(3),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                         GestureDetector(
                                                                onTap:  () {
                                                                        // viewing image
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => OpenMedia(
                                                                                      mediamodel: currentMedia,
                                                                                      userModel: widget.userModel,
                                                                                      senderUid: currentMedia.senderId!,
                                                                                      date: currentMedia.createdOn!,
                                                                                      type: currentMedia.type!,
                                                                                    )));
                                                                      },
                                                                child: (messageType ==
                                                                        "image")
                                                                    ? ConstrainedBox(
                                                                        constraints: const BoxConstraints(
                                                                            maxHeight:
                                                                                200,
                                                                            maxWidth:
                                                                                150),
                                                                        child: Image
                                                                            .network(
                                                                          currentMedia
                                                                              .fileUrl
                                                                              .toString(),
                                                                        ),
                                                                      )
                                                                    : (messageType ==
                                                                            "video")
                                                                        ? // image
                                                                        FutureBuilder(
                                                                            future:
                                                                                _initializeVideoPlayerFuture,
                                                                            builder:
                                                                                (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                                              return Stack(
                                                                                children: [
                                                                                  ConstrainedBox(
                                                                                    constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
                                                                                    child: AspectRatio(
                                                                                      aspectRatio: videoController!.value.aspectRatio,
                                                                                      child: VideoPlayer(videoController!),
                                                                                    ),
                                                                                  ),
                                                                                  const Positioned(
                                                                                      bottom: 10,
                                                                                      left: 10,
                                                                                      child: Icon(
                                                                                        Icons.play_arrow,
                                                                                        color: Colors.white,
                                                                                        size: 25,
                                                                                      )),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ) 
                                                                           : Container(
                                                                            color: Colors.amber,
                                                                           )),
                                                                          //text
                                                     Container(
                                                                            color: Colors.amber,
                                                                           ),
                                                  ]),
                            );
                          },
                        ): const Text("No Shared Media"),
                      );
                   } else if (snapshot.hasError) {
                      return const Text(
                          "Error Occured !! Please check our internet Connection");
                    } else if (snapshot.hasData==false) {
                      return const Text("No shared Media");
                    }
                    else{
                      return const Text("No shared Media");
                    }
                   } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
               Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Group Members",style: TextStyle(color:Color.fromARGB(255, 240, 217, 148),fontWeight: FontWeight.bold, fontSize: 20),))
              ,ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 350,
                    maxHeight: 400,
                  maxWidth:MediaQuery.sizeOf(context).width/1.2 ),
           
                child: ListView(children:List.generate(widget.groupMembers.length, (index) {
                  bool isAdmin=false;
                  if(widget.groupMembers[index].uId == widget.groupRoomModel.createdBy){
                    isAdmin=true;
                  }

                  return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:  const Color.fromARGB(255, 240, 217, 148),
                                backgroundImage: NetworkImage(widget.groupMembers[index].profileUrl!),
                                radius: 30,
                                ),
                                title: Text(widget.groupMembers[index].name!),
                                subtitle:  Text(widget.groupMembers[index].email!),
                                trailing: isAdmin 
                                ? Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: const Color.fromARGB(255, 240, 217, 148)),
                                  child: const Text("Admin"),)
                                :PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>[
                                    PopupMenuItem(child:
                                     ListTile(
                                      onTap: (){
                                        removeMember( widget.groupMembers[index].uId!);
                                       
                                      },
                                      leading: Icon(Icons.remove),
                                     title: Text("Remove"),))
                                  ],),
                            );
                }),),
                
              ),
              
              Visibility(
                visible:(widget.groupRoomModel.createdBy==widget.userModel.uId) ?true :false ,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color:  const Color.fromARGB(255, 240, 217, 148),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateGroupPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel, existing: true,exisitingGroupRoom: widget.groupRoomModel,)));
                    },
                    title: const Text("add a member"),
                    trailing: const Icon(Icons.add),
                  ),
                )
                 )
        ],
      ),
    );
  }

  // removing a member
  Future removeMember(String newMemberId)async{
  try {
    // Reference to the specific group chat document
    DocumentReference groupChatRef = FirebaseFirestore.instance.collection("GroupChats").doc(widget.groupRoomModel.groupRoomId);

    // Update the participantsId field by adding the new participant
    await groupChatRef.update(
      {
      "participantsId.${newMemberId}" :FieldValue.delete()
        });


    print("Participant removed successfully.");
  } catch (e) {
    print("Error removing participant: $e");
  }
}
}
