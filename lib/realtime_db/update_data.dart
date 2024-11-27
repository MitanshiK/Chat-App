import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({super.key});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final databaseRef = FirebaseDatabase.instance.ref("Users");
  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
            child: ListView(children: [
              
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    label: Text("Provide registered email to update info"),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Update",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
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
              ElevatedButton(onPressed: () {
              
              }, child: const Text("Update "))
            ])));
  }
}
