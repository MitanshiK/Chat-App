
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

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
      appBar: AppBar(title: const Text("Video Player"),),
      body: Column(
        children: [
        FutureBuilder(future: _initializeVideoPlayerFuture, 
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return AspectRatio(aspectRatio: videoController!.value.aspectRatio,
            child: const VideoPlayer());
          }
          else {
            return const CircularProgressIndicator();
          }
    
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
                child: const Text("select a File")),
            ElevatedButton(onPressed: () {
              UploadFile().then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("uploaded to storage successfully")));
              });
            }, child: const Text("Upload File")),

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
        debugPrint("${pickedFile!.path!}");
       _initializeVideoPlayerFuture =videoController!.initialize();
    });
    // final file =File(pickedFile!.path!);

    // final uploadRef= FirebaseStorage.instance.ref().child("images/${pickedFile!.name}");// creating a reference for path where image will be uploaded
    // uploadRef.putFile(file);

  }
}