// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class SaveData extends StatefulWidget {
//   const SaveData({super.key});

//   @override
//   State<SaveData> createState() => _SaveDataState();
// }

// class _SaveDataState extends State<SaveData> {
// TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   final dbRef=FirebaseDatabase.instance.ref();
//   late final saveRef;
  

// @override
//   void initState() {
  
//     saveRef=dbRef.child("Students/")
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text("Realtime database"),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 keyboardType: TextInputType.name,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     label: Text("Name"),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//               TextField(
//                 controller: ageController,
//                 keyboardType: TextInputType.number,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     label: Text("Age"),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     label: Text("Phone No"),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//               TextField(
//                 controller: addressController,
//                 keyboardType: TextInputType.streetAddress,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     label: const Text("address"),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//               TextField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: const InputDecoration(
//                     label: Text("Email"),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//               ElevatedButton(onPressed: (){

//               }, child: Text("Save Data"))
//             ])
//             )
//             );
//   }
// }