import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj/firestore/delete_data.dart';
import 'package:proj/firestore/listening_changes.dart';
import 'package:proj/firestore/querying_collection.dart';
import 'package:proj/firestore/show_data.dart';
import 'package:proj/firestore/student_model.dart';
import 'package:proj/firestore/update_data.dart';
import 'package:proj/realtime_db/update_data.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
   TextEditingController nameController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController emailController = TextEditingController();
    TextEditingController DocIdController = TextEditingController();

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
               SizedBox(height: 10,),

               TextField(
                controller: DocIdController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Doc Id(for custom id button)"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
               SizedBox(height: 10,),

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
                  
                  getId= await usersCollection.id;
                  print("document id is $getId");
                  // adding value to collection
                  }, child: Text("save to firestore")),

                  // save data with custom document Id
                  Expanded(
                    child: ElevatedButton(onPressed: ()async{
                       final usersCollection = FirebaseFirestore.instance.collection("Students");
                               
                                //  usersCollection.add(student);
                               await  usersCollection.doc(DocIdController.text).set({
                                 "name":nameController.text,
                                 "rollNo":int.parse(rollController.text),
                                 "email":emailController.text,
                                 "id" :DocIdController.text
                     } );
                    
                    }, child: Text("save with custom document Id")),
                  )
                ],
              ),

              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowData()));
              }, child: Text("show all Data")),

              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListeningChanges()));
              }, child: Text("realtime data")),

              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> QueryingCollection()));
              }, child: Text("Querying Collection")),

              
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdatingDocument()));
              }, child: Text("Update Document")),

              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DeleteDocData()));
              }, child: Text("Deleted data")),
              
              ])
              )
              );
  }
  
}