
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/user_model.dart';

class UiHelper{
// to show loading
  static void loadingDialogFun(BuildContext context,String content){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
       return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              CircularProgressIndicator(),
              SizedBox(height: 20,),
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
        title: Text(" Error"),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
           Navigator.pop(context);
          }, child: Text("Ok"))
        ],
      );
        }, );
  }

// to choose if we want a video or picture camera to open
  static String cameraType(BuildContext context ){
    String CamType="";
    showDialog(
      context: context,
     builder: (BuildContext context) { 
      return AlertDialog(
       title: Text("Camera"),
       content: Row(children: [
        // for picture
        IconButton(onPressed: (){
        CamType= "picture";
        }, icon: Icon(Icons.image)),
       
        // for video
        IconButton(onPressed: (){
        CamType="video";
        }, icon: Icon(Icons.video_camera_back))
       ],)
      );
      });
      return CamType;
  }
}