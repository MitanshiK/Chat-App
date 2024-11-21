
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video_Player extends StatefulWidget {
  const Video_Player({super.key});

  @override
  State<Video_Player> createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {

 VideoPlayerController? videoController; // video controller for videoPlayer
 late Future<void> _initializeVideoPlayerFuture;  // future for video
 late final storage; // getting instance of firebase storage

 var pickedFile; // variable contains the file we picked


  void storageFun() {
     storage =
      FirebaseStorage.instance; 
  }

  bool picked=false;


 @override
  void initState() {
    // videoController=VideoPlayerController.file(File(pickedFile!.path!));
    if(picked==false){
      videoController= VideoPlayerController.networkUrl(Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _initializeVideoPlayerFuture =videoController!.initialize();
    }


    storageFun();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Video Player"),),
      body: Column(
        children: [
        FutureBuilder(future: _initializeVideoPlayerFuture, 
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return AspectRatio(aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!));
          }
          else return CircularProgressIndicator();
    
          }, ),
          ElevatedButton(onPressed: (){
          if(videoController!.value.isPlaying){
            videoController!.pause();
          }
          else{
            videoController!.play();
          }
          }, child: Icon(videoController!.value.isPlaying ?Icons.pause: Icons.play_arrow)),

          ////////////////
           ElevatedButton(
                onPressed: () 
                {
                  selectFile();
                },
                child: Text("select a File")),
            ElevatedButton(onPressed: () {
              UploadFile().then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("uploaded to storage successfully")));
              });
            }, child: Text("Upload File")),

      ],)
    );
  }
    Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      picked=true;
      pickedFile = result!.files.first;

      ////
    
       //
    });
  }

  Future UploadFile() async{
    setState(() {
         videoController=VideoPlayerController.file(pickedFile!.path!);
        print("${pickedFile!.path!}");
       _initializeVideoPlayerFuture =videoController!.initialize();
    });
    // final file =File(pickedFile!.path!);

    // final uploadRef= FirebaseStorage.instance.ref().child("images/${pickedFile!.name}");// creating a reference for path where image will be uploaded
    // uploadRef.putFile(file);

  }
}