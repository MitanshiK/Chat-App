
import 'package:flutter/material.dart';

class NoStoryUpdates extends StatelessWidget {
   NoStoryUpdates({super.key });


  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.all(20),
     child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(image: AssetImage("assets/talk.png"),
        height: MediaQuery.sizeOf(context).width/2,
        width: MediaQuery.sizeOf(context).width/2,
        ),
        SizedBox(height: 30,),
        Text("No Recent Updates",style: TextStyle(fontFamily: "EuclidCircularB",fontWeight: FontWeight.bold,fontSize: 18),)
      ],
     ),
    
    );
  }
}