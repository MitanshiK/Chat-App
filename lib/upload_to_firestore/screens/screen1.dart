import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/helpers/ui_helper.dart';
import 'package:proj/main.dart';
import 'package:proj/upload_to_firestore/screens/screen2.dart';
import 'package:permission_handler/permission_handler.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String? capturedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
        await requestPermission();
                },
                child: const Text("Capture image")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Screen2()));
                },
                child: const Text("Uploaded Images")),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
      if(await permission.isGranted){
       await fromCamera();
      }
    } else {
      await fromCamera();
    }
  }

  Future fromCamera() async {
    late final captured;
    captured = await ImagePicker().pickImage(source: ImageSource.camera);

    if (captured != null) {
      setState(() {
        capturedFile = captured.path;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Do you want to upload this image ?"),
            content: Row(
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await uploadToFirestore();
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () {
                      fromCamera();
                      Navigator.pop(context);
                    },
                    child: const Text("No"))
              ],
            ),
          );
        },
      );
    }
  }

  Future uploadToFirestore() async {
    UiHelper.loadingDialogFun(context, "Uploading............");
    try {
      await FirebaseStorage.instance
          .ref("Uploaded_images")
          .child(uuid.v1())
          .putFile(File(capturedFile!));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Image Uploaded Successfully"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("error occured $e")));
    }
    //  mediaUrl = await result.ref.getDownloadURL();
  }
}
