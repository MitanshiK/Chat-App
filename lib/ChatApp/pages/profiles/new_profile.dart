import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/for_media/open_media.dart';
import 'package:video_player/video_player.dart';

class NewProfile extends StatefulWidget {
   NewProfile({super.key, required this.mediaList ,required this.userModel});
   final List<MediaModel> mediaList;
   final UserModel userModel;

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
String messageType="";

  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Shared Media",style: TextStyle(fontFamily: "EuclidCircularB"),),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 600,
            maxWidth: MediaQuery.sizeOf(context).width
          ),
          child: 
          
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisSpacing: 20,
                    mainAxisExtent: 160,
                    crossAxisCount: 2,
                    childAspectRatio: 0.2
              ),
              children: List.generate(widget.mediaList.length, (int index) {
                if (widget.mediaList[index].type == "image") {
                  messageType = "image";
                } else if (widget.mediaList[index].type == "video") {
                  videoController = VideoPlayerController.networkUrl(
                      Uri.parse(widget.mediaList[index].fileUrl!));
                  _initializeVideoPlayerFuture = videoController!.initialize();
                  messageType = "video";
                }
                return Container(
                  // height: MediaQuery.sizeOf(context).width/3,
                  // width: MediaQuery.sizeOf(context).width/3,
                  padding: const EdgeInsets.all(3),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              // viewing image
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpenMedia(
                                            mediamodel: widget.mediaList[index],
                                            senderUid:
                                                widget.mediaList[index].senderId!,
                                            date: widget
                                                .mediaList[index].createdOn!,
                                            type: widget.mediaList[index].type!,
                                            userModel: widget.userModel,
                                          )));
                            },
                            child: (messageType == "image")
                                ? Container(
                                    // constraints: BoxConstraints(
                                      height:
                                          MediaQuery.sizeOf(context).width / 3,
                                      width: MediaQuery.sizeOf(context).width,
                                    // ),
                                    child: Image.network(
                                      widget.mediaList[index].fileUrl.toString(), fit: BoxFit.cover,
                                    ),
                                  )
                                : (messageType == "video")
                                    ? // image
                                    FutureBuilder(
                                        future: _initializeVideoPlayerFuture,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          return Stack(
                                            children: [
                                              Container(
                                                // constraints: BoxConstraints(
                                                    height:
                                                        MediaQuery.sizeOf(context).width /3,
                                                     width: MediaQuery.sizeOf(context).width,
                                                    // ),
                                                child:
                                                //  AspectRatio(
                                                //   aspectRatio: videoController!
                                                //       .value.aspectRatio,
                                                //   child:
                                                   VideoPlayer(
                                                      videoController!),
                                                // ),
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
                                    : Container()),
                        //text
                        const SizedBox(
                          height: 5,
                        ),
                      ]),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
