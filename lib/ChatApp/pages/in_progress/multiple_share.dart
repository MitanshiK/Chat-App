// import 'package:flutter/material.dart';

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
// import 'package:proj/ChatApp/pages/audio_player.dart';
// import 'package:proj/main.dart';
// import 'package:video_player/video_player.dart';

// class MultipleShare extends StatefulWidget {
//   MultipleShare(
//       {super.key,
//       required this.mediaToSend,
//       //  this.chatRoom,
//       // this.groupRoomModel,
//       required this.userModel,
//       required this.type});
//  final dynamic mediaToSend;
// //  final ChatRoomModel? chatRoom;
// //  final GroupRoomModel? groupRoomModel;
// final  UserModel userModel;
//  final String type;

//   @override
//   State<MultipleShare> createState() => _MultipleShareState();
// }

// class _MultipleShareState extends State<MultipleShare> {
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
//                           AudioPlayChat(audioFile: widget.mediaToSend),
                          
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
//      String? mediaUrl;

//     if (widget.mediaToSend != "") {

//        if(widget.chatRoom!=null){
//        final  result = await FirebaseStorage.instance
//           .ref("AllSharedMedia")
//           .child(widget.chatRoom!.chatRoomId.toString())
//           .child("sharedMedia")
//           .child(uuid.v1())
//           .putFile(File(widget.mediaToSend));

//        // getting the download link of image uploaded in storage
//        mediaUrl = await result.ref.getDownloadURL();
//            }

//            // group chat
//            else if(widget.groupRoomModel!=null){
//           final    result = await FirebaseStorage.instance
//           .ref("AllSharedMedia")
//           .child(widget.groupRoomModel!.groupRoomId.toString())
//           .child("sharedMedia")
//           .child(uuid.v1())
//           .putFile(File(widget.mediaToSend));

//            // getting the download link of image uploaded in storage
//            mediaUrl = await result.ref.getDownloadURL();

//            }
              
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

//         if(widget.chatRoom!=null){
//       // creating a messages collection inside chatroom docs and saving messages in them
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoom!.chatRoomId)
//           .collection("messages")
//           .doc(newMessage.mediaId)
//           .set(newMessage.toMap())
//           .then((value) {
//         debugPrint("message sent");
//       });

//       // setting last message in chatroom and saving in firestore
//       widget.chatRoom!.lastMessage = widget.type;
//       widget.chatRoom!.lastTime=newMessage.createdOn; // time 
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatRoom!.chatRoomId)
//           .set(widget.chatRoom!.toMap());
//          }
          

//           // group chat //////
//          else if(widget.groupRoomModel!=null){
//       // creating a messages collection inside  groupchatroom docs and saving messages in them
//       FirebaseFirestore.instance
//           .collection("GroupChats")
//           .doc(widget.groupRoomModel!.groupRoomId)
//           .collection("messages")
//           .doc(newMessage.mediaId)
//           .set(newMessage.toMap())
//           .then((value) {
//         debugPrint("message sent");
//       });

//       // setting last message in groupchatroom and saving in firestore
//       widget.groupRoomModel!.lastMessage = widget.type;
//       widget.groupRoomModel!.lastTime=newMessage.createdOn; // time
//       widget.groupRoomModel!.lastMessageBy=newMessage.senderId; 
//       FirebaseFirestore.instance
//           .collection("GroupChats")
//           .doc(widget.groupRoomModel!.groupRoomId)
//           .set(widget.groupRoomModel!.toMap());
//          }
 
//     }
//   }
//   /////////////////////////
// }