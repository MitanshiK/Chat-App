import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/main.dart';
import 'package:video_player/video_player.dart';

class SendMedia extends StatefulWidget {
  SendMedia(
      {super.key,
      required this.mediaToSend,
      required this.chatRoom,
      required this.userModel,
      required this.type});
  dynamic  mediaToSend;                       // PlatformFile mediaToSend;
  ChatRoomModel chatRoom;
  UserModel userModel;
  String type;

  @override
  State<SendMedia> createState() => _SendMediaState();
}

class _SendMediaState extends State<SendMedia> {
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video
  bool picked = false;

  @override
  void initState() {
    if (widget.type == "video") {
      videoController =
          VideoPlayerController.file(File(widget.mediaToSend.path!));
      _initializeVideoPlayerFuture = videoController!.initialize();
    }
    if(widget.type== "audio"){
      print("audio reached to sending class");
      sendMedia();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(               // shows preview od media
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (widget.type == "image")
                ? Expanded(child: Image.file(File(widget.mediaToSend.path!)))
                : // 1st
                (widget.type == "video")
                    ? FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: videoController!.value.aspectRatio,
                                child: VideoPlayer(videoController!),
                              ),
                              Positioned(
                                top: MediaQuery.sizeOf(context).height / 3,
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (videoController!
                                              .value.isPlaying) {
                                            videoController!.pause();
                                          } else {
                                            videoController!.play();
                                          }
                                        },
                                        icon: Icon(
                                          videoController!.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_circle,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Placeholder(), //2nd
          ],
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
            sendMedia();
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
            size: 40,
          )),
    );
  }

  void sendMedia() async {
    late MediaModel newMessage;
late final result;

    if (widget.mediaToSend != "") {
      
      if(widget.type=="audio"){
 result = await FirebaseStorage.instance
          .ref("AllSharedMedia")
          .child(widget.chatRoom.chatRoomId.toString())
          .child("sharedMedia")
          .child(uuid.v1())
          .putFile(File(widget.mediaToSend));
      }
      else{
       result = await FirebaseStorage.instance
          .ref("AllSharedMedia")
          .child(widget.chatRoom.chatRoomId.toString())
          .child("sharedMedia")
          .child(uuid.v1())
          .putFile(File(widget.mediaToSend.path!));
      }

      // getting the download link of image uploaded in storage
      String? mediaUrl = await result.ref.getDownloadURL();
      if (widget.type == "image") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "image");
      } else if (widget.type == "video") {
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "video");

      }else if (widget.type=="audio"){
        newMessage = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "audio");
      }


      // creating a messages collection inside chatroom docs and saving messages in them
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatRoomId)
          .collection("messages")
          .doc(newMessage.mediaId)
          .set(newMessage.toMap())
          .then((value) {
        debugPrint("message sent");
      });

      // setting last message in chatroom and saving in firestore
      widget.chatRoom.lastMessage = widget.type;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatRoomId)
          .set(widget.chatRoom.toMap());
    }
  }
  /////////////////////////
}
