import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:video_player/video_player.dart';

class ShowStory extends StatefulWidget {
  const ShowStory(
      {super.key, required this.firebaseUser, required this.userModel});
  final User firebaseUser;
  final UserModel userModel;

  @override
  State<ShowStory> createState() => _ShowStoryState();
}

class _ShowStoryState extends State<ShowStory> {
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

 List<MediaModel> recentStoryList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: 
             ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(widget.userModel.profileUrl!),
              ),
              title: Text(
                widget.userModel.name!,
                style: const TextStyle(color: Colors.white  ,fontFamily:"EuclidCircularB"),
              ),
            ),

       
      ),
      body:
          Container(
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width / 1.1,
            height: MediaQuery.sizeOf(context).height / 1.1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .doc(widget.userModel.uId)
                    .collection("status")
                    .orderBy("createdOn", descending: true)
                    .snapshots(), // to convert into streams
          
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                      recentStories(dataSnapshot); // to get only stories uploaded within 24 hours
                      return CarouselSlider(
                          items: List.generate(recentStoryList.length, (index) {
                            var currentStory=recentStoryList[index];
                    
                            if (recentStoryList[index].type=="video") {
                              // setting video in controller
                              videoController = VideoPlayerController.networkUrl(
                                  Uri.parse(currentStory.fileUrl!));
                              _initializeVideoPlayerFuture =
                                  videoController!.initialize();
                              videoController!.value.isPlaying == true;
                            } 
          
                            return
                                // ConstrainedBox(
                                //   constraints: BoxConstraints(
                                //     maxHeight: MediaQuery.sizeOf(context).height,
                                //     maxWidth: MediaQuery.sizeOf(context).width,
                                //     ),
                                //     child:
                                (currentStory.type == "image")
                                    ? 
                                      Center(
                                        child: Expanded(
                                            child: Image.network(
                                                currentStory.fileUrl!)))
                                    : // 1st
                                    (currentStory.type == "video")
                                        ? Center(
                                            child: FutureBuilder(
                                              future: _initializeVideoPlayerFuture,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic> snapshot) {
                                                videoController!.value.isPlaying ==
                                                    true;
                                                return Stack(
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio: videoController!
                                                          .value.aspectRatio,
                                                      child: VideoPlayer(
                                                          videoController!),
                                                    ),
                                                    Positioned(
                                                      top:
                                                          MediaQuery.sizeOf(context)
                                                                  .height /
                                                              3,
                                                      child: SizedBox(
                                                        width: MediaQuery.sizeOf(
                                                                context)
                                                            .width,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                if (videoController!
                                                                    .value
                                                                    .isPlaying) {
                                                                  videoController!
                                                                      .pause();
                                                                } else {
                                                                  videoController!
                                                                      .play();
                                                                }
                                                              },
                                                              icon: Icon(
                                                                videoController!
                                                                        .value
                                                                        .isPlaying
                                                                    ? Icons.pause
                                                                    : Icons
                                                                        .play_circle,
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
                                            ),
                                          )
                                        : Container(
                                            color: Colors.amber,
                                          );
                            // );
                          }),
                          options: CarouselOptions(
                            pauseAutoPlayOnTouch: true,
                            height: MediaQuery.sizeOf(context).height / 1.1,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.9,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: true,
                            // autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            // onPageChanged:
                            scrollDirection: Axis.horizontal,
                          ));
          
                      //////
                    } else if (snapshot.hasError) {
                      return const Text(
                          "Error Occured !! Please check our internet Connection");
                    } else {
                      return const Text("Say Hi to " ,style: TextStyle(fontFamily:"EuclidCircularB"));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
      
    
    );
  }

  void recentStories(QuerySnapshot<Object?> dataSnapshot) {
    for (var i in dataSnapshot.docs) {
      late final currentStory = MediaModel.fromMap( // data into model
          i.data() as Map<String, dynamic>);

      DateTime a = currentStory.createdOn!;
      DateTime b = DateTime.now();
      var diff = b.difference(a).inHours; // to know if its been 24 hours or not

      if (diff <= 24) {
       
          recentStoryList.add(currentStory);
        
      }
      // print("difference between current time ${DateTime.now().hour} and story${currentStory.createdOn!.hour} is ${diff} ");
    }
  }
}
