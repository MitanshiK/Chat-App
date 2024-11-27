import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
// List<String> imageList=[];
 final storageRef = FirebaseStorage.instance.ref();

Future<List<String>> getItems() async{
  List<String> imageList=[];
       final a=  await storageRef.child('Uploaded_images/').listAll();
          final b = await a.items.first.getDownloadURL();
          debugPrint(" list of all the images are $b");

          for(var  i in a.items){
             final b = await i.getDownloadURL();
             imageList.add(b);
             debugPrint(b);
          }  
 return imageList;
}

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(title: const Text("Images"),  backgroundColor: Colors.white,),
      body:Container(padding: const EdgeInsets.all(10),
      child:
      // imageList.isEmpty
      // ? Center(child: CircularProgressIndicator(),)
      // :
       FutureBuilder(
         future: getItems(),
         builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) { 
         if( snapshot.data==null){
          return const Center(child: CircularProgressIndicator(),);
         }
         return GridView.count(
          crossAxisCount: 3,
          scrollDirection: Axis.vertical ,
          mainAxisSpacing: 20,
          children: List.generate(snapshot.data!.length, (index)=> 
               Image(image: NetworkImage(snapshot.data![index])) ),
          ); 
         
         
         },
       )
    )
    );
  }
}