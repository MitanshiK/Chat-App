// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:proj/ChatApp/models/chat_room_model.dart';
// import 'package:proj/ChatApp/models/firebase_helper.dart';
// import 'package:proj/ChatApp/models/media_model.dart';
// import 'package:proj/ChatApp/models/user_model.dart';
// import 'package:proj/ChatApp/pages/show_story.dart';
// import 'package:proj/ChatApp/pages/story_file_upload.dart';

// //2

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:proj/ChatApp/models/chat_room_model.dart';
// import 'package:proj/ChatApp/models/group_room_model.dart';
// import 'package:proj/ChatApp/models/media_model.dart';
// import 'package:proj/ChatApp/models/user_model.dart';
// import 'package:proj/main.dart';
// import 'package:proj/storage/audio_player.dart';
// import 'package:video_player/video_player.dart';
// class Stories extends StatefulWidget {
//   Stories({super.key, required this.firebaseUser, required this.userModel});
//   final User firebaseUser;
//   final UserModel userModel;

//   @override
//   State<Stories> createState() => _StoriesState();
// }

// class _StoriesState extends State<Stories> {
  
//    List<String> usersWithStoryList=[];
//   PlatformFile? pickedMedia;
//   bool hasStory = true;
//   bool UserStory=true;

// @override
//   void initState() {
//    UserStory=hasUploadedStory(widget.userModel.uId!);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("status"),
//         backgroundColor: const Color.fromARGB(255, 240, 217, 148),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             // user
//             ListTile(
//               onTap: () {
//                 chooseDialog();
//               },
//               leading: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   GestureDetector(
//                     onTap:UserStory
//                     ? () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ShowStory(
//                                   firebaseUser: widget.firebaseUser,
//                                   userModel: widget.userModel)));
//                     }
//                     :(){
//                       chooseDialog();
//                     },
//                     child: CircleAvatar(
//                         radius: 40,
//                         backgroundColor: UserStory
//                             ? const Color.fromARGB(255, 22, 227, 207)
//                             : Colors.transparent,
//                         child: CircleAvatar(
//                           radius: 25,
//                           backgroundImage:
//                               NetworkImage(widget.userModel.profileUrl!),
//                         )),
//                   ),
//                   Visibility(
//                     visible: hasStory ? false : true,
//                     child: const Positioned(
//                       bottom: -5,
//                       right: -5,
//                       child: Icon(
//                         Icons.add_circle,
//                         color: Color.fromARGB(255, 240, 217, 148),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               title: Text("My Status"),
//               subtitle: Text("Tap to add status update"),
//             ),
//             Divider(),
//             Container(
//                 padding: EdgeInsets.all(10),
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Recent Updates",
//                   style: TextStyle(
//                       color: Colors.grey, fontWeight: FontWeight.bold),
//                 )),
//             // friends
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("chatrooms")
//                   .where("participantsId.${widget.userModel.uId}",
//                       isEqualTo: true)
//                   .snapshots(), // get the chatroom that contain current User
//               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   if (snapshot.hasData) {
//                     QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

//                     return ConstrainedBox(
//                       constraints: BoxConstraints(
//                           maxHeight: MediaQuery.sizeOf(context).height / 2),
//                       child: ListView.builder(
//                         itemCount: dataSnapshot.docs.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           usersWithStory(dataSnapshot); ////////////////////////////////////

//                           ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                               dataSnapshot.docs[index].data()
//                                   as Map<String, dynamic>);

//                           // to get targetUser Id
//                           Map<String, dynamic> participants = chatRoomModel
//                               .participantsId!; // getting participants
//                           List<String> participantsList = participants.keys
//                               .toList(); // getting participants keys and saving in list
//                           participantsList.remove(widget.userModel
//                               .uId); // removing currentUser key so that we are left with targetuser id
//                           /////
//                           hasStory= hasUploadedStory(participantsList[0]);         /// to check//////////////
                      
//                           return FutureBuilder(
//                             future: FirebaseHelper.getUserModelById(
//                                 participantsList[0]), // passing target user id
                               
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.done) {
//                                 if (snapshot.hasData) {
//                                   UserModel userData =
//                                       snapshot.data as UserModel;

//                                   return (hasStory==true)? Container(
//                                     margin: EdgeInsets.only(top: 15),
//                                     child: ListTile(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ShowStory(
//                                                           firebaseUser: widget
//                                                               .firebaseUser,
//                                                           userModel:
//                                                               userData)));
//                                         },
//                                         title: Text(userData.name.toString()),
//                                         leading: CircleAvatar(
//                                           radius: 40,
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 22, 227, 207),
//                                           child: CircleAvatar(
//                                             radius: 25,
//                                             backgroundColor:
//                                                 const Color.fromARGB(
//                                                     255, 158, 219, 241),
//                                             backgroundImage: NetworkImage(
//                                                 userData.profileUrl.toString()),
//                                           ),
//                                         )),
//                                   )
//                                   :Container();
//                                 } else {
//                                   return Container();
//                                 }
//                               } else {
//                                 return Container();
//                               }
//                             },
//                           );
//                         },
//                       ),
//                     );

//                     /////
//                   } else if (snapshot.hasError) {
//                     return const Center(
//                         child: Text(" Please check your network"));
//                   } else {
//                     return const Center(child: Text(" no chats"));
//                   }
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),

//             ////////////////
//           ],
//         ),
//       ),
//     );
//   }

//   // selecting image from gallary to send
//   Future<void> selectImage(FileType mediaType) async {
//     final result = await FilePicker.platform.pickFiles(type: mediaType);
//     setState(() {
//       pickedMedia = result?.files.first;
//     });
//   }

//   void chooseDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Camera"),
//           content: Row(
//             children: [
//               // for picture
//               IconButton(
//                 onPressed: () async {
//                   await selectImage(FileType.image);
//                   if (pickedMedia != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => StoryFileUpload(
//                           status: pickedMedia!.path,
//                           userModel: widget.userModel,
//                           type: 'image',
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 icon: const Icon(Icons.image),
//               ),

//               // for video
//               IconButton(
//                 onPressed: () async {
//                   await selectImage(FileType.video);
//                   // Navigator.pop(context);
//                   if (pickedMedia != null) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => StoryFileUpload(
//                             status: pickedMedia!.path,
//                             userModel: widget.userModel,
//                             type: 'video',
//                           ),
//                         ));
//                   }
//                 },
//                 icon: const Icon(Icons.video_camera_back),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
  
//   //to check show only those users who have uploaded status
//   bool hasUploadedStory(String participantsList) {
//      List<MediaModel> recentStoryList=[];

//      FirebaseFirestore.instance
//                     .collection("ChatAppUsers")
//                     .doc(widget.userModel.uId)
//                     .collection("status")
//                     .orderBy("createdOn", descending: true)
//                     .snapshots()
//                     .listen((value) {
         
//       for (var i in value.docs) {
//         late final currentStory = MediaModel.fromMap(// data into model
//           i.data() );

//         DateTime a = currentStory.createdOn!;
//         DateTime b = DateTime.now();
//         var diff =
//             b.difference(a).inHours; // to know if its been 24 hours or not
//   print("difference between current time ${DateTime.now().hour} and story${currentStory.createdOn!.hour} is ${diff} ");
//         if (diff <= 24) {
//           recentStoryList.add(currentStory);
//         }
//       } 
//          debugPrint ("no if stories ${participantsList} is ${recentStoryList.length}");
//     });

 
//     if(recentStoryList.isEmpty){
//        return false;
//       }
//       else {
//          recentStoryList.clear();
//         return true;
//       }
      
//   }

//   void usersWithStory(QuerySnapshot<Object?> dataSnapshot){
//     // StreamBuilder(
//     //   stream: null,
//     //    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  },)

//   }
// }

// /////////////////////////////////////////////////////////////// send media


// class SendMedia extends StatefulWidget {
//   SendMedia(
//       {super.key,
//       required this.mediaToSend,
//        this.chatRoom,
//       this.groupRoomModel,
//       required this.userModel,
//       required this.type});
//   dynamic mediaToSend;
//   ChatRoomModel? chatRoom;
//   GroupRoomModel? groupRoomModel;
//   UserModel userModel;
//   String type;

//   @override
//   State<SendMedia> createState() => _SendMediaState();
// }

// class _SendMediaState extends State<SendMedia> {
//   VideoPlayerController? videoController; // video controller for videoPlayer
//   late Future<void> _initializeVideoPlayerFuture; // future for video

//   @override
//   void initState() {
//     if (widget.type == "video") {
//       videoController =
//           VideoPlayerController.file(File(widget.mediaToSend));
//       _initializeVideoPlayerFuture = videoController!.initialize();
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             (widget.type == "image")
//                 ? Expanded(child: Image.file(File(widget.mediaToSend)))
//                 : // 1st
//                 (widget.type == "video")
//                     ? FutureBuilder(
//                         future: _initializeVideoPlayerFuture,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<dynamic> snapshot) {
//                           return Stack(
//                             children: [
//                               AspectRatio(
//                                 aspectRatio: videoController!.value.aspectRatio,
//                                 child: VideoPlayer(videoController!),
//                               ),
//                               Positioned(
//                                 top: MediaQuery.sizeOf(context).height / 3,
//                                 child: Container(
//                                   width: MediaQuery.sizeOf(context).width,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {
//                                           if (videoController!
//                                               .value.isPlaying) {
//                                             videoController!.pause();
//                                           } else {
//                                             videoController!.play();
//                                           }
//                                         },
//                                         icon: Icon(
//                                           videoController!.value.isPlaying
//                                               ? Icons.pause
//                                               : Icons.play_circle,
//                                           size: 80,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ) :
//                       (widget.type=="audio") ? //2nd

//                       Container(
//                         color: Colors.white,
//                         child: Column(
//                         children: [
//                           AudioPlay(audioFile: widget.mediaToSend),
                          
//                         ],
//                       ))
//                     : Placeholder(), 
//           ],
//         ),
//       ),
//       floatingActionButton: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//             sendImage();
//           },
//           icon: const Icon(
//             Icons.send,
//             color: Colors.white,
//             size: 40,
//           )),
//     );
//   }

//   void sendImage() async {
//     late MediaModel newMessage;

//     if (widget.mediaToSend != "") {
//       final result = await FirebaseStorage.instance
//           .ref("AllSharedMedia")
//           .child(widget.chatRoom.chatRoomId.toString())
//           .child("sharedMedia")
//           .child(uuid.v1())
//           .putFile(File(widget.mediaToSend));

//       // getting the download link of image uploaded in storage
//       String? mediaUrl = await result.ref.getDownloadURL();
//       if (widget.type == "image") {
//         newMessage = MediaModel(
//             // creating message
//             mediaId: uuid.v1(),
//             senderId: widget.userModel.uId,
//             fileUrl: mediaUrl,
//             createdOn: DateTime.now(),
//             type: "image");
//       } else if (widget.type == "video") {
//         newMessage = MediaModel(
//             // creating message
//             mediaId: uuid.v1(),
//             senderId: widget.userModel.uId,
//             fileUrl: mediaUrl,
//             createdOn: DateTime.now(),
//             type: "video");
//       }else if (widget.type == "audio") {
//         newMessage = MediaModel(
//             // creating message
//             mediaId: uuid.v1(),
//             senderId: widget.userModel.uId,
//             fileUrl: mediaUrl,
//             createdOn: DateTime.now(),
//             type: "audio");
//       }
//       // creating a messages collection inside chatroom docs and saving messages in them
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoom.chatRoomId)
//           .collection("messages")
//           .doc(newMessage.mediaId)
//           .set(newMessage.toMap())
//           .then((value) {
//         debugPrint("message sent");
//       });

//       // setting last message in chatroom and saving in firestore
//       widget.chatRoom.lastMessage = widget.type;
//       widget.chatRoom.lastTime=newMessage.createdOn; // time 
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoom.chatRoomId)
//           .set(widget.chatRoom.toMap());
//     }
//   }
//   /////////////////////////
// }
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/read_contacts.dart';
import 'package:proj/ChatApp/pages/send_media.dart';

class ShareBottomModal extends StatefulWidget {
  ShareBottomModal({super.key , this.chatRoomModel ,required this.userModel ,this.groupRoomModel});
GroupRoomModel? groupRoomModel;
 UserModel userModel;
 ChatRoomModel?   chatRoomModel;

  @override
  State<ShareBottomModal> createState() => _ShareBottomModalState();
}

class _ShareBottomModalState extends State<ShareBottomModal> {
    PlatformFile? pickedMedia;
   String? capturedFile;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
        maxChildSize: 1,
        builder: (BuildContext context,
                ScrollController
                    scrollController) // scrollcontroller for dragging the menu up and down
            {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20))),
            child:  Column(
              children: <Widget>[
                // Row 1
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //1
                   GestureDetector(
                    onTap: () async{
                       await selectImage(FileType.image); 
                                             Navigator.pop(context);// await bcs , it will wait for pic to be selected then navigate to next page
               
                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "image",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "image",
                                                        )));
                                            }
                                                         
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 236, 113, 154),
                          child: Icon(Icons.image ,color: Colors.white,),
                         ),
                         Text("Image")
                       ],
                     ),
                   ),

                   //2
                    GestureDetector(
                    onTap: ()async{
                       await selectImage(FileType.video);
                        Navigator.pop(context);

                        
                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "video",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "video",
                                                        )));
                                            }
                                                        
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.video_camera_back ,color: Colors.white,),
                         ),
                         Text("Video")
                       ],
                     ),
                   ),

                   //3
                    GestureDetector(
                    onTap: (){
                      chooseDialog();
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 81, 131, 157),
                          child: Icon(Icons.camera_alt,color: Colors.white,),
                         ),
                         Text("Camera")
                       ],
                     ),
                   )
                    ],
                ),
               const SizedBox(height: 20,),
                 // Row 2
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //1
                    GestureDetector(
                    onTap: ()async{
                                            await selectImage(FileType.audio);
                                             Navigator.pop(context); 


                                           
                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "audio",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "audio",
                                                        )));
                                            }
                                            print(
                                                "${File(pickedMedia!.path!)} is audio path  ${pickedMedia!.path}");
                                    
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.audio_file ,color: Colors.white,),
                         ),
                         Text("Audio")
                       ],
                     ),
                   ),

                   //2
                    GestureDetector(
                    onTap: (){
                      
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.location_pin ,color: Colors.white,),
                         ),
                         Text("Location")
                       ],
                     ),
                   ),

                   //3
                    GestureDetector(
                    onTap: (){
                       Navigator.pop(context);    
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                       ReadContacts(chatRoomModel: widget.chatRoomModel!, userModel: widget.userModel,)));
                      
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.contacts,color: Colors.white,),
                         ),
                         Text("Contacts")
                       ],
                     ),
                   )
                  ])
              ],
            ),
          );
        }
        );
  }
    // selecting image from gallary to send
  Future selectImage(FileType mediaType) async {
    final result = await FilePicker.platform.pickFiles(type: mediaType);

    setState(() {
      pickedMedia = result!.files.first;
    });
  }
   void chooseDialog(){
    showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      title: const Text("Camera"),
                                                      content: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          // for picture
                                                          IconButton(
                                                            iconSize: 40,
                                                              onPressed: () async {
                                                                await fromCamera(
                                                                    "picture");
                                                                          
                                                                if(widget.chatRoomModel!=null){
                                                                Navigator.push(context, MaterialPageRoute(
                                                                        builder: (context) => SendMedia(
                                                                            mediaToSend:capturedFile!,
                                                                            chatRoom: widget.chatRoomModel,
                                                                            userModel: widget.userModel,
                                                                            type: "image")));
                                                                }

                                                                else if (widget.groupRoomModel!=null){
                                                                         Navigator.push(context, MaterialPageRoute(
                                                                        builder: (context) => SendMedia(
                                                                            mediaToSend:capturedFile!,
                                                                            groupRoomModel: widget.groupRoomModel,
                                                                            userModel: widget.userModel,
                                                                            type: "image")));
                                                                  
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                  Icons.image)),

                                                          // for video
                                                          IconButton(
                                                            
                                                             iconSize: 40,
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                                await fromCamera(
                                                                    "video");


                                                              if(widget.chatRoomModel!=null){
                                                                Navigator.push(context, MaterialPageRoute(
                                                                        builder: (context) => SendMedia(
                                                                            mediaToSend:capturedFile!,
                                                                            chatRoom: widget.chatRoomModel,
                                                                            userModel: widget.userModel,
                                                                            type: "video")));
                                                                }

                                                                else if (widget.groupRoomModel!=null){
                                                                         Navigator.push(context, MaterialPageRoute(
                                                                        builder: (context) => SendMedia(
                                                                            mediaToSend:capturedFile!,
                                                                            groupRoomModel: widget.groupRoomModel,
                                                                            userModel: widget.userModel,
                                                                            type: "video")));
                                                                  
                                                                }

                                                              },
                                                              icon: const Icon(Icons
                                                                  .video_camera_back),
                                                                  
                                                                  )
                                                        ],
                                                      ));
                                                });
  }

  // video Or image from camera
  Future fromCamera(String cameraType) async {
   late final captured ;
    if(cameraType=="picture"){
     captured = await ImagePicker().pickImage(source: ImageSource.camera);
    }else if( cameraType=="video"){
       captured = await ImagePicker().pickVideo(source: ImageSource.camera);
    }

    if(captured != null) {
      setState(() {
         capturedFile=captured.path;
      }); 
    }
  }

}