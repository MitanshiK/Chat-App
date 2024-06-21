import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video_picker extends StatefulWidget {
  const Video_picker({super.key});

  @override
  State<Video_picker> createState() => _Video_pickerState();
}


class _Video_pickerState extends State<Video_picker> {

 var pickedFile;
 bool picked=false;
  VideoPlayerController? videoController; // video controller for videoPlayer
 late Future<void> _initializeVideoPlayerFuture; 

 @override
  void initState() {
    if(picked==false){
    videoController=VideoPlayerController.networkUrl(Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _initializeVideoPlayerFuture=videoController!.initialize();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(title: Text("video Picker"),),
    body: Column(children: [
      ElevatedButton(onPressed: (){

      }, child: Text("Pick Video")),
      FutureBuilder(future: _initializeVideoPlayerFuture, 
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if(snapshot.connectionState==ConnectionState.done){
          return AspectRatio(aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
          );
        }else{
          return CircularProgressIndicator();
        }
       },
       )
      
    ],),
    );
  }
  Future picker() async{
        final result = await FilePicker.platform.pickFiles();
    setState(() {
      picked=true;
      pickedFile = result?.files.first;
    });
    // final result=await FilePicker.platform.pickFiles();
    // setState(() {
    //   picked=true;
    //     pickedFile = result!.files.first;

    //     try{  
    //  videoController=VideoPlayerController.file(pickedFile.path);
    // _initializeVideoPlayerFuture=videoController!.initialize();  
    //     }catch(e){
    //       print("this is the video exception ${e}");
    //     } 

    // });
  }
}