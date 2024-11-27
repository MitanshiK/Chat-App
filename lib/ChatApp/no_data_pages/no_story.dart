
import 'package:flutter/material.dart';

class NoStoryUpdates extends StatelessWidget {
   const NoStoryUpdates({super.key });


  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.all(20),
     child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(image: const AssetImage("assets/talk.png"),
        height: MediaQuery.sizeOf(context).width/2,
        width: MediaQuery.sizeOf(context).width/2,
        ),
        const SizedBox(height: 30,),
        const Text("No Recent Updates",style: TextStyle(fontFamily: "EuclidCircularB",fontWeight: FontWeight.bold,fontSize: 18),)
      ],
     ),
    
    );
  }
}