import 'package:flutter/material.dart';

class UiHelper{
// to show loading
  static void loadingDialogFun(BuildContext context,String content){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
       return AlertDialog(
        backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20,),
              Text(content)
            ],),
          ),
       );
      }, );

  }

  // to show some message
  static void messageDialog(BuildContext context ,String content){
    showDialog(
      barrierDismissible: false,
      context: context,
       builder: (BuildContext context) { 
      return AlertDialog(
        title: const Text(" Error"),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
           Navigator.pop(context);
          }, child: const Text("Ok"))
        ],
      );
        }, );
  }

// // to choose if we want a video or picture camera to open
//   static String cameraType(BuildContext context ){
//     String CamType="";
//     showDialog(
//       context: context,
//      builder: (BuildContext context) { 
//       return AlertDialog(
//        title: const Text("Camera"),
//        content: Row(children: [
//         // for picture
//         IconButton(onPressed: (){
//         CamType= "picture";
//         }, icon: const Icon(Icons.image)),
       
//         // for video
//         IconButton(onPressed: (){
//         CamType="video";
//         }, icon: const Icon(Icons.video_camera_back))
//        ],)
//       );
//       });
//       return CamType;
//   }
}