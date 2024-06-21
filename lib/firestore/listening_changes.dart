import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Listening to realtime changes
class ListeningChanges extends StatefulWidget {
  const ListeningChanges({super.key});

  @override
  State<ListeningChanges> createState() => _ListeningChangesState();
}

class _ListeningChangesState extends State<ListeningChanges> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('Students').snapshots();


// getting querysnapshot
  void docPrint(){     // iterating all the doc in a collection 
  var documents=FirebaseFirestore.instance
    .collection('Students')
    .get()
    .then((QuerySnapshot querySnapshot) {  //A QuerySnapshot is returned from a collection query, and allows you to 
                                              //inspect the collection, such as how many documents exist within it, gives access to the documents within the collectio
        querySnapshot.docs.forEach((doc) {
            print(doc["name"]);
        });
    });
  }

// getting DocumentSnapshot
  void docPrint2(){   // get a single doc data by its id 
    FirebaseFirestore.instance
    .collection('Students')
    .doc("ABC")
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.data());
    });
  }
  @override
  void initState() {
docPrint2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("listening to changes in the firestore Data"),),
      body: Container(padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child:
      // getting query snapshot  
      // ElevatedButton(onPressed: (){
      //   docPrint();
      // }, 
      // child: Text("documents Print"))
      //

      StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
 
        if(snapshot.hasData==true){
        return Container(
          height: 500,
          width: MediaQuery.sizeOf(context).width,
        
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return 
                // ElevatedButton(onPressed: (){
                //   print("${data["name"]}");
                // }, child: Text("hello"));
          
              ListTile(
                title: Text(data['name']),
               );
          
            }).toList(),
          ),
        );}
        
        else 
       {
          return Text("Loading");
        }

      },
    )
    
         ),
    );
  }
}