import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proj/firestore/student_model.dart';

class QueryingCollection extends StatefulWidget {
  const QueryingCollection({super.key});

  @override
  State<QueryingCollection> createState() => _QueryingCollectionState();
}

class _QueryingCollectionState extends State<QueryingCollection> {
  final firestoreRef=FirebaseFirestore.instance.collection("Students");
  List<StudentModel> QueryData=[];

 // filtering for rollno 
 void RollnoQuery() async{
 await firestoreRef.where("rollNo",isLessThanOrEqualTo: 13).get().then((QuerySnapshot querySnapshot){
   for (var doc in querySnapshot.docs) {
    debugPrint("${doc["name"]} ${doc["rollNo"]}");
    //  QueryData.add(StudentModel(doc["name"],doc["rollNo"],doc["id"],doc["email"]));
    }
     print(QueryData.length);
  } );
 }
  
// limit Query 
// only debugPrints data of specified no of rows from start 
void limitDocs() async{
await firestoreRef.limit(2).get().then((QuerySnapshot querySnapshot){
  for (var element in querySnapshot.docs) {
    debugPrint(element["name"]);
  }

});
}

// Limit to last query
// works same as limit 
void limitToLastDocs() async{
await firestoreRef.limitToLast(2).get().then((QuerySnapshot querySnapshot){
  for (var element in querySnapshot.docs) {
    debugPrint(element["name"]);
  }

});
}

void orderby(){
  firestoreRef.orderBy("rollNo",descending: false).get().then((QuerySnapshot querySnapshot) {
   for (var doc in querySnapshot.docs) {
   debugPrint("${doc["name"]}  ${doc["rollNo"]}");
    }
  });
}

// start and end cursors
void endAndStartCursors(){
 firestoreRef.orderBy("rollNo")   // compulsory when using start and end cursors
             .startAt([11])       // to specify starting point
             .endAt([23])         // to specify ending point 
             .get()
             .then((QuerySnapshot querySnapshot) {
              for (var doc in querySnapshot.docs) {
               debugPrint("${doc["name"]}  ${doc["rollNo"]}");
               }
             });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Querying the documents in collection"),),
      body: Container(padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: SizedBox(
      
        height: 600,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Query output in debug console"),
             ElevatedButton(onPressed: (){
              RollnoQuery();
             }, child: const Text("Rollno less than 13")),

             ElevatedButton(onPressed: (){
              limitDocs();
             }, child: const Text("limit Query")),

              ElevatedButton(onPressed: (){
              limitDocs();
             }, child: const Text("limit To LastQuery")),

             ElevatedButton(onPressed: (){
              orderby();
             }, child: const Text("orderby ascending")),

             
             ElevatedButton(onPressed: (){
              endAndStartCursors();
             }, child: const Text("starting and ending cursors"))
          ],
        )
        // ListView(children: List.generate(QueryData.length, (index) {
        // return ListTile(title: Text(QueryData[index].name.toString()),
        // leading:  Text(QueryData[index].rollno.toString()),
        // subtitle:  Text(QueryData[index].id.toString()),);  
        // })
        // ),
       ),
      )
    );
  }
}