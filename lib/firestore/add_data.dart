import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proj/firestore/delete_data.dart';
import 'package:proj/firestore/listening_changes.dart';
import 'package:proj/firestore/querying_collection.dart';
import 'package:proj/firestore/show_data.dart';
import 'package:proj/firestore/update_data.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
   TextEditingController nameController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController emailController = TextEditingController();
    TextEditingController docIdController = TextEditingController();

var getId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Firebase Firestore"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children:<Widget> [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Name"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: rollController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("RollNo"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
      
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Email"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
               const SizedBox(height: 10,),

               TextField(
                controller: docIdController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Doc Id(for custom id button)"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
               const SizedBox(height: 10,),

              Row(
                children: [
                  ElevatedButton(onPressed: ()async{
                           
                   final usersCollection = FirebaseFirestore.instance.collection("Students").doc();
                             
                              //  usersCollection.add(student);
                             await  usersCollection.set({
                               "name":nameController.text,
                               "rollNo":int.parse(rollController.text),
                               "email":emailController.text,
                               "id" :usersCollection.id
                   } );
                  
                  getId=  usersCollection.id;
                  debugPrint("document id is $getId");
                  // adding value to collection
                  }, child: const Text("save to firestore")),

                  // save data with custom document Id
                  Expanded(
                    child: ElevatedButton(onPressed: ()async{
                       final usersCollection = FirebaseFirestore.instance.collection("Students");
                               
                                //  usersCollection.add(student);
                               await  usersCollection.doc(docIdController.text).set({
                                 "name":nameController.text,
                                 "rollNo":int.parse(rollController.text),
                                 "email":emailController.text,
                                 "id" :docIdController.text
                     } );
                    
                    }, child: const Text("save with custom document Id")),
                  )
                ],
              ),

              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShowData()));
              }, child: const Text("show all Data")),

              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListeningChanges()));
              }, child: const Text("realtime data")),

              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const QueryingCollection()));
              }, child: const Text("Querying Collection")),

              
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const UpdatingDocument()));
              }, child: const Text("Update Document")),

              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const DeleteDocData()));
              }, child: const Text("Deleted data")),
              
              ])
              )
              );
  }
  
}