import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  FetchData( {super.key });

  @override
  State<FetchData> createState() => _FetchDataState();

}

class _FetchDataState extends State<FetchData> {
 late final databaseRef;
 late var snapshot ;
  @override
  void initState() {
    databaseRef=FirebaseDatabase.instance.ref().child("Users"); // creating refernce for database ode 
    snapshot =databaseRef.child("Users").get(); //getting data inside Users node
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child:   ListView.builder(
              itemBuilder: (BuildContext context, int index) { 
                return FetchedItems(snapshot: snapshot, );
               },)  ));
  }
}


// listitem widget
class FetchedItems extends StatefulWidget {
 FetchedItems( {super.key,required this.snapshot});
 var snapshot;

  @override
  State<FetchedItems> createState() => _FetchedItemsState();
}

class _FetchedItemsState extends State<FetchedItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      color: const Color.fromARGB(255, 235, 203, 241),
      child: Column(children: [
        Text("${widget.snapshot.value}" ,style: TextStyle(color: Colors.black),),
        Text("age" ,style: TextStyle(color: Colors.black),),
        Text("phone no" ,style: TextStyle(color: Colors.black),),
        Text("address" ,style: TextStyle(color: Colors.black),),
        Text("Email address" ,style: TextStyle(color: Colors.black),),

        
      ],),
    );
  }
}