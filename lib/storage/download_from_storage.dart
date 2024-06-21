//     https://firebasestorage.googleapis.com/v0/b/flutter1-a89ae.appspot.com/o/images%2FScreenshot_2024-06-12-14-54-14-99_1c337646f29875672b5a61192b9010f9.jpg?alt=media&token=5f416813-c548-40f0-912d-953bf2a6a679
// https://firebasestorage.googleapis.com/v0/b/flutter1-a89ae.appspot.com/o/images%2FSnapchat-1804721178.mp4?alt=media&token=03144e58-e297-44d2-a0b8-61e98f498916
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proj/storage/strorage.dart';
import 'package:video_player/video_player.dart';

class DownloadData extends StatefulWidget {
  const DownloadData({super.key});

  @override
  State<DownloadData> createState() => _DownloadDataState();
}

class _DownloadDataState extends State<DownloadData> {
 final StorageRef = FirebaseStorage.instance.ref();
 late final imageRef;
 String imgUrl="";

 VideoPlayerController? videoController; // video controller for videoPlayer
 late Future<void> _initializeVideoPlayerFuture;  // future for video
  bool picked=false;

 @override
  void initState() {
    if(picked==false){
      videoController= VideoPlayerController.networkUrl(Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _initializeVideoPlayerFuture =videoController!.initialize();
    }
   imageRef=StorageRef.child("images/Screenshot_2024-06-12-14-54-14-99_1c337646f29875672b5a61192b9010f9.jpg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Download data from Storage"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
        children: [
          ElevatedButton(
            onPressed: (){
           downloadImg();
          }, child: Text("Download Image")),
         imgUrl==""
         ? Text("no Data") 
         : FutureBuilder(future: _initializeVideoPlayerFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
            return AspectRatio(
              aspectRatio: videoController!.value.aspectRatio,
              child: VideoPlayer(videoController!),
            );
           },
          ),
           ElevatedButton(onPressed: (){
          if(videoController!.value.isPlaying){
            videoController!.pause();
          }
          else{
            videoController!.play();
          }
          }, child: Icon(videoController!.value.isPlaying ?Icons.pause: Icons.play_arrow)),
        //  Image(image: NetworkImage(imgUrl))
         ],),
         
      ),
    );
  }
  Future downloadImg() async{
    var i=await FirebaseStorage.instance.ref().child("images/Snapchat-1804721178.mp4").getDownloadURL();
    setState(() {
       imgUrl= i;
       videoController=VideoPlayerController.networkUrl(Uri.parse(imgUrl));
       _initializeVideoPlayerFuture =videoController!.initialize();
    });
    print("$imgUrl");
  }
}