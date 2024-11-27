import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealtimeDb extends StatefulWidget {
  const RealtimeDb({super.key});

  @override
  State<RealtimeDb> createState() => _RealtimeDbState();
}

class _RealtimeDbState extends State<RealtimeDb> {
  final DatabaseRef = FirebaseDatabase.instance.ref("Users").orderByChild("age");
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
String? dbData;

  ///
  var snapShot;

  @override
  void initState() {
    snapShot = DatabaseRef.get();
    getData();
    super.initState();
  }


  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Realtime database"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Name"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Age"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Phone No"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: addressController,
                keyboardType: TextInputType.streetAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label:  Text("address"),
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
              ElevatedButton(
                  onPressed: () {
                    var id = FirebaseDatabase.instance.ref().child("Users").push().key;

                    // final userRef = FirebaseDatabase.instance.ref("Users");

                    var user = {
                      "Name": nameController.text,
                      "Age": ageController.text,
                      "Phone No": phoneController.text,
                      "address": addressController.text,
                      "email": emailController.text,
                      "id": id
                    };

                    try {
                      // DatabaseRef.child(id.toString()).set(user);
                      // userRef.set(user);
                    } catch (e) {
                      debugPrint("error is $e");
                    }
                  },
                  child: const Text("Save Data")),
                Text("$dbData")
            ],
          ),
        ));
  }

  void getData() {
  //  var values;
    DatabaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
        // values = data;
        // debugPrint("data is  $values");
        debugPrintData(data.toString());
    });       
    // return values.toString();
  }
  
  void debugPrintData(String data){
  // final  databaseReference = FirebaseDatabase.instance.ref().child("Users").orderByChild()
    setState(() {
        dbData= data; 
    });
    debugPrint("$dbData");
}

}


// DatabaseReference starCountRef =
//         FirebaseDatabase.instance.ref('posts/$postId/starCount');
// starCountRef.onValue.listen((DatabaseEvent event) {
//     final data = event.snapshot.value;
//     updateStarCount(data);
// });
