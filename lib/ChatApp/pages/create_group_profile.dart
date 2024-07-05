import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/models/ui_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/pages/groupchatroom.dart';


class CreateGroupProfile extends StatefulWidget {
  CreateGroupProfile({super.key ,required this.firebaseUser , required this.userModel ,required this.groupRoomModel ,required this.groupMembers});
  final  UserModel userModel;
  final  User firebaseUser;  
  final GroupRoomModel  groupRoomModel;
  List<UserModel> groupMembers;

  @override
  State<CreateGroupProfile> createState() => _CreateGroupProfileState();
}

class _CreateGroupProfileState extends State<CreateGroupProfile> {

 File? profilePic;
  bool picked = false;
  String name = "";


  @override
  Widget build(BuildContext context) {
    final groupProfileKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 217, 148),
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 240, 217, 148),
                    backgroundImage: (picked == true)
                        ? FileImage(profilePic!)
                        : null,
                    child: (picked == false)
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.black,
                          )
                        : null),
                Positioned(
                    bottom: -1,
                    right: 5,
                    // change profile
                    child: GestureDetector(
                        onTap: () {
                          showoptions();
                        },
                        child: const Icon(Icons.edit))),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: groupProfileKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Name"), border: OutlineInputBorder()),
                          validator: (value){
                           if(value!.trim()==""){
                              return "empty name field";
                           }
                           else
                           {return null;}
                          },
                          onSaved: (newValue) {
                            setState(() {
                              name=newValue!;
                            });
                          },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                          onPressed: () {

                             groupProfileKey.currentState!.save();
                             if( groupProfileKey.currentState!.validate()){
                             uploadData();
                             
                             }
                          },
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 240, 217, 148))),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ),
                  
                    
                  ],
                )),
                  Expanded(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width/1.2,
                     height: MediaQuery.sizeOf(context).height/3,
                     
                      child: ListView(
                          children:List.generate(widget.groupMembers.length, (index){
                           return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:  Color.fromARGB(255, 240, 217, 148),
                                backgroundImage: NetworkImage(widget.groupMembers[index].profileUrl!),
                                radius: 30,
                                ),
                                title: Text(widget.groupMembers[index].name!),
                                subtitle:  Text(widget.groupMembers[index].email!),
                            );
                          }),
                        ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
  //////////////

///////1

void showoptions(){
 showDialog(context: context,
  builder: ( context) { 
   return AlertDialog(
    title: const Text("Upload Profile from"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      ListTile(
        onTap: (){
          fromCamera(ImageSource.camera);
          Navigator.pop(context);
        },
        leading: const Icon(Icons.camera),
      title: const Text("Open Camera"),),

      ListTile(
          onTap: (){
        selectProfile();
          Navigator.pop(context);
          },
          leading: const Icon(Icons.image),
               title: const Text("Upload from Gallary"),),
    ],),
   );
   });
}
//////2
//from gallary
  Future selectProfile() async {        // select image from gallary 
    final result = await FilePicker.platform.pickFiles(type: FileType.image,);

    if(result!=null){
      cropImage(result.files.first);
    }
  }
  // from camera
    void fromCamera(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if(pickedFile != null) {
      cropImageCamera(pickedFile);
    }
  }
///////3

void cropImageCamera(XFile file) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20
    );

    if(croppedImage != null) {
      setState(() {
         picked = true;
        profilePic = File(croppedImage.path);
      });
    }
  }

  void cropImage(PlatformFile? selectedImg) async{           // to crop the image 
      final croppedImage = await ImageCropper().cropImage(             
      sourcePath: selectedImg!.path!,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20
    );
     print("path of cropped image file is ${croppedImage!.path} ");
     
       setState(() {
      picked = true;
      profilePic = File(croppedImage.path);
    });
    print("path of cropped image file is ${profilePic!.path}  and picked value is $picked");
  }

  // 4//////////////////////////////////////////////////to change
  void uploadData() async{
    // uploading image to the firebase storage 
    UiHelper.loadingDialogFun(context, "Saving..");
    final result=await FirebaseStorage.instance.ref("ProfilePictures").child(widget.groupRoomModel.groupRoomId.toString()).putFile(profilePic!);  
    
    // getting the download link of image uploaded in storage
    String? imageUrl= await result.ref.getDownloadURL();


    // saving name and imageurl in the empty fields of usermodel
    widget.groupRoomModel.groupName=name;
    widget.groupRoomModel.profilePic =imageUrl;

   // updating data in firestore 
    await FirebaseFirestore.instance.collection("GroupChats").doc(widget.groupRoomModel.groupRoomId).set(widget.groupRoomModel.toMap()).then((value){
    debugPrint("profile complete !");
    
    Navigator.pop(context);   
    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => GroupRoomPage(firebaseUser: widget.firebaseUser, userModel: widget.userModel, groupMembers: widget.groupMembers, groupRoomModel: widget.groupRoomModel,))));
    });
  }
  
}