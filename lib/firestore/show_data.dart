import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});


  @override
  State<ShowData> createState() => _ShowDataState();
  
}

class _ShowDataState extends State<ShowData> {


  final usersCollection=FirebaseFirestore.instance.collection("Students");
  final db= FirebaseFirestore.instance.databaseId;

  var allData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Show Data"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children:<Widget> [  
               ElevatedButton(onPressed: ()async{
                // getData();
            //  final  postDocRef=FirebaseFirestore.instance.collection("Students").doc();
            //  await postDocRef.set({
            //   "rollno":postDocRef.id
            //  });
             var data1=await usersCollection.get();
             setState(() {
                allData=data1.docs.map((e) =>e.data()).toList();
              });
             debugPrint(allData);
               }, child: const Text("id")),
              allData==null?const Text("null"): SizedBox(
                height: 500,
                width: MediaQuery.sizeOf(context).width,
                child: ListView(
                  children: List.generate(allData.length, (index) => Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(allData[index].toString()))),),
              )

            ]
            )
        )
    );
  }
Future<void>  getData() async{
 var data1=await usersCollection.get();

  allData=data1.docs.map((e) =>e.data()).toList();
 debugPrint(allData);
}

}

//  const postDocRef=firebaseClient.firestore().collection('post_details').doc();
//     await postDocRef.set({
//       post_pid: postDocRef.id,
//       // ....rest of your data
//     })