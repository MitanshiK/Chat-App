
import 'package:flutter/material.dart';

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
}