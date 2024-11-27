import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  late final storage; // getting instance of firebase storage


   VideoPlayerController? videoController; // video controller for videoPlayer
 late Future<void> _initializeVideoPlayerFuture;  // future for video

  PlatformFile? pickedFile; // variable contains the file we picked


  void storageFun() {
     storage =
      FirebaseStorage.instance; 

  }
  bool picked=false;

  @override
  void initState() {

/////
      if(picked==false){
      videoController= VideoPlayerController.networkUrl(Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _initializeVideoPlayerFuture =videoController!.initialize();
    }

//////

    storageFun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Firebase Storage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
           //////pdfViewer
  picked ?
   AspectRatio(

    aspectRatio: 10/5,
    child: 
    // PDFView(
    //   filePath: pickedFile!.path,),
    PDFView(
        filePath: pickedFile!.path,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        onError: (error) {
          debugPrint(error);
        },
        onPageError: (page, error) {
          debugPrint('$page: ${error.toString()}');
        },
       
     
    )
  )
  : const Text("pdfViewer"),

            ////////// video player
 FutureBuilder(future: _initializeVideoPlayerFuture, 
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return AspectRatio(aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!));
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

            //////// image 
          // picked ?  Image.file(File(pickedFile!.path!), width: 200,
          //     height: 200,)
             
          //  : SizedBox(height: 10,),
           ///////
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
            // Text("${pickedFile..name}")
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      picked=true;
      pickedFile = result?.files.first;

     ///
      videoController=VideoPlayerController.file(File(pickedFile!.path!));
        debugPrint(pickedFile!.path!);
       _initializeVideoPlayerFuture =videoController!.initialize();
       ////
    });
  }

  Future UploadFile() async{
    final file =File(pickedFile!.path!);

    final uploadRef= FirebaseStorage.instance.ref() .child("images/${pickedFile!.name}");// creating a reference for path where image will be uploaded
    uploadRef.putFile(file);


  }
}
