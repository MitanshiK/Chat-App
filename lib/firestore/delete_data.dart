import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteDocData extends StatefulWidget {
  const DeleteDocData({super.key});

  @override
  State<DeleteDocData> createState() => _DeleteDocDataState();
}

class _DeleteDocDataState extends State<DeleteDocData> {
TextEditingController docIdController=TextEditingController();
TextEditingController fieldNameController=TextEditingController();

final firestoreRef=FirebaseFirestore.instance.collection("Students");

// to delete whole document if field name is empty
void deleteDoc(String docId){
  firestoreRef.doc(docId).delete().then((value) {
    debugPrint ("document deleted successfuly");
  });
}

// to delete document field if name provided
void deleteDocField(String docId,String fieldName){
  firestoreRef.doc(docId)
  .update({fieldName : FieldValue.delete()}).then((value) {
  debugPrint("field value deleted successfully");
  });

}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Delete data"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children:<Widget> [ 
                    TextField(
                controller: docIdController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Doc Id"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
                 const SizedBox(height: 10,),
                  TextField(
                controller: fieldNameController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Field Name(Optional)"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
                const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){

                if(fieldNameController.text.trim()=="" ){
                  deleteDoc(docIdController.text);
                }
                else{
                  deleteDocField(docIdController.text, fieldNameController.text);
                }

              }, child: const Text("Remove Data"))
            ])
        )
    );
  }
}