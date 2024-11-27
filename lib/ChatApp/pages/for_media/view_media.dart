import 'dart:io';

import 'package:cubit_form/cubit_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/Blocs/video_arrow_bloc.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/in_progress/all_chatrooms.dart';
import 'package:video_player/video_player.dart';
// viewing media before sending
class ViewMedia extends StatefulWidget {
  const ViewMedia({super.key ,required this.type ,required this.mediaToSend ,required this.firebaseUser, required this.usermodel});
  final User firebaseUser;
  final UserModel usermodel;
  final String type;
  final String? mediaToSend;

  @override
  State<ViewMedia> createState() => _ViewMediaState();
}

class _ViewMediaState extends State<ViewMedia> {
    VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

  @override
  void initState() {
    if (widget.type == "video") {
      videoController =
          VideoPlayerController.file(File(widget.mediaToSend!));
      _initializeVideoPlayerFuture = videoController!.initialize();
    }
     if(widget.mediaToSend==null || widget.mediaToSend==""){
      Navigator.pop(context);
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
                ? Expanded(child: Image.file(File(widget.mediaToSend!) ,cacheWidth: 300,))
                : // 1st
                (widget.type == "video")
                    ? FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return 
                           BlocProvider<VideoStateBloc>(
                            create: (_)=> VideoStateBloc(false),
                            child: 
                            BlocBuilder<VideoStateBloc, bool>(
  builder: (BuildContext context, state) {
    return Center(
      child: Stack(
        alignment: Alignment.center, // Align children at the center
        children: [
          AspectRatio(
            aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!),
          ),
          // Center the play/pause icon
          IconButton(
            onPressed: () {
              if (videoController!.value.isPlaying) {
                videoController!.pause();
                context.read<VideoStateBloc>().add(VideoPause());
              } else {
                videoController!.play();
                context.read<VideoStateBloc>().add(VideoPlay());
              }
            },
            icon: Icon(
              state ? Icons.pause : Icons.play_circle,
              size: 80,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  },
)
                          );
                        
                          // Stack(
                          //   children: [
                          //     AspectRatio(
                          //       aspectRatio: videoController!.value.aspectRatio,
                          //       child: VideoPlayer(videoController!),
                          //     ),
                          //     Positioned(
                          //       top: MediaQuery.sizeOf(context).height / 3,
                          //       child: SizedBox(
                          //         width: MediaQuery.sizeOf(context).width,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: [
                          //             IconButton(
                          //               onPressed: () {
                          //                 if (videoController!
                          //                     .value.isPlaying) {
                          //                   videoController!.pause();
                          //                 } else {
                          //                   videoController!.play();
                          //                 }
                          //               },
                          //               icon: Icon(
                          //                 videoController!.value.isPlaying
                          //                     ? Icons.pause
                          //                     : Icons.play_circle,
                          //                 size: 80,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // );
                       
                        },
                      ) 
                    : const Placeholder(), 
          ],
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context)=>AllChatRooms(firebaseUser: widget.firebaseUser, userModel: widget.usermodel, type:widget.type, mediaToSend: widget.mediaToSend!,) ));
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
            size: 40,
          )),
    );
  }
  


}


