import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/main.dart';
import 'package:video_player/video_player.dart';

class StoryFileUpload extends StatefulWidget {
  StoryFileUpload(
      {super.key,
      required this.status,
      required this.userModel,
      required this.type});
 final dynamic status;
 final UserModel userModel;
 final String type;

  @override
  State<StoryFileUpload> createState() => _StoryFileUploadState();
}

class _StoryFileUploadState extends State<StoryFileUpload> {
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

  @override
  void initState() {
    if (widget.type == "video") {
      videoController =
          VideoPlayerController.file(File(widget.status));
      _initializeVideoPlayerFuture = videoController!.initialize();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (widget.type == "image")
                ? Expanded(child: Image.file(File(widget.status)))
                : // 1st
                (widget.type == "video")
                    ? FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return Stack(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height/1.2 ,maxWidth: MediaQuery.sizeOf(context).width/1.2),
                                child: AspectRatio(
                                  aspectRatio: videoController!.value.aspectRatio,
                                  child: VideoPlayer(videoController!),
                                ),
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
                    : Placeholder(), 
          ],
        ),
      ),
             
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
            uploadStatus();
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
            size: 40,
          )),
    );
  }

  void uploadStatus() async {
    late MediaModel statusinfo;
    

    if (widget.status != "") {

   final result = await FirebaseStorage.instance
          .ref("AllSharedMedia")
          .child(widget.userModel.uId!)
          .child("status")
          .child(uuid.v1())
          .putFile(File(widget.status));

      // getting the download link of image uploaded in storage
      String? mediaUrl = await result.ref.getDownloadURL();


      if (widget.type == "image") {
       try{ 
        statusinfo = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "image");
            }catch(e){
              print(" unable to store in firestore $e ");
            }

      } else if (widget.type == "video") {
        statusinfo = MediaModel(
            // creating message
            mediaId: uuid.v1(),
            senderId: widget.userModel.uId,
            fileUrl: mediaUrl,
            createdOn: DateTime.now(),
            type: "video");
      }
      // creating a messages collection inside chatroom docs and saving messages in them
      FirebaseFirestore.instance
          .collection("ChatAppUsers")
          .doc(widget.userModel.uId)
          .collection("status")
          .doc(statusinfo.mediaId)
          .set(statusinfo.toMap())
          .then((value) {
        debugPrint("status uploaded");
      });

    }
  }
}
