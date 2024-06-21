import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UpdatingDocument extends StatefulWidget {
  const UpdatingDocument({super.key});

  @override
  State<UpdatingDocument> createState() => _UpdatingDocumentState();
}

class _UpdatingDocumentState extends State<UpdatingDocument> {
TextEditingController docIdController=TextEditingController();
TextEditingController fieldController=TextEditingController();
TextEditingController updateDataController=TextEditingController();

  @override
  Widget build(BuildContext context) {
  final firestoreRef=FirebaseFirestore.instance.collection("Students");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("updating data in doc"),),
      body: Container(padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Container(
        height: 600,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  
          TextField(
                controller: docIdController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Doc Id to update"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 20,),
              
              // Row(children: [
                TextField(
                controller: fieldController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("field to update"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
            
              // SizedBox(width: 15,),
              
                TextField(
                controller: updateDataController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("enter Value"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              // ],),
              ElevatedButton(onPressed: (){
                if(fieldController.text.trim() !="" || updateDataController.text.trim()!=""){
                  firestoreRef.doc(docIdController.text)
                  .update({fieldController.text.toString() : updateDataController.text})
                  .then((value) {
                   print("value Updated");
                  });
                  
                }
              }, child: Text("Update"))

          ])
          )
          )
          );
  }
}