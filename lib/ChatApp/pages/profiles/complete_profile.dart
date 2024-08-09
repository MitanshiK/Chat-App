import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/models/ui_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/home_page.dart';




import 'package:flutter/widgets.dart';

class CompleteUserProfile extends StatefulWidget {
  final  UserModel userModel;
  final User firebaseUser;             // firebase auth user

  const CompleteUserProfile({super.key ,required this.userModel ,required this.firebaseUser});

  @override
  State<CompleteUserProfile> createState() => _CompleteUserProfileState();
}

class _CompleteUserProfileState extends State<CompleteUserProfile> {

  // PlatformFile? profilePic;
  File? profilePic;
  bool picked = false;
  String name = "";
@override
  void initState() {
   if(widget.userModel.name!=null || widget.userModel.name!=""){
    name=widget.userModel.name!;
   }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
        // String? userId =Provider.of<StateClass>(context).uId; 
    final profileKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
        title: const Text("Complete Profile"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
       
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 240, 217, 148),
                    backgroundImage: (picked == true)
                        ? FileImage(profilePic!)
                        : ((widget.userModel.profileUrl!=null) ? NetworkImage(widget.userModel.profileUrl.toString()): const AssetImage("assets/woman.png") as ImageProvider),
                    // child: (picked == false)
                    //     ? const Icon(
                    //         Icons.person,
                    //         size: 60,
                    //         color: Colors.black,
                    //       )
                    //     : null
                        ),
                   Positioned(
                    bottom: -1,
                    right: 5,
                    // change profile
                    child:
                     GestureDetector(
                        onTap: () {
                          showoptions();
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor:  Color.fromARGB(255, 240, 217, 148),
                          child: Icon(Icons.edit)))
                        
                        ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: profileKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: (name!="") ? name :"",
                       style: const TextStyle(fontFamily:"EuclidCircularB")  ,
                      decoration: const InputDecoration(
                          label: Text("Name"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ), border: OutlineInputBorder()),
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
                             profileKey.currentState!.save();
                             if( profileKey.currentState!.validate()){
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
                            style: TextStyle(fontFamily:"EuclidCircularB" ,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

///////1

void showoptions(){
 showDialog(context: context,
  builder: ( context) { 
   return AlertDialog(
    title: const Text("Upload Profile from"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      ListTile(
        onTap: (){
          fromCamera(ImageSource.camera);
          Navigator.pop(context);
        },
        leading: const Icon(Icons.camera),
      title: const Text("Open Camera"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),),

      ListTile(
          onTap: (){
        selectProfile();
          Navigator.pop(context);
          },
          leading: const Icon(Icons.image),
               title: const Text("Upload from Gallary"  ,style: TextStyle(fontFamily:"EuclidCircularB")  ),),
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
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
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

  // 4
  void uploadData() async{
    // uploading image to the firebase storage 
    UiHelper.loadingDialogFun(context, "Saving..");
    final result=await FirebaseStorage.instance.ref("ProfilePictures").child(widget.userModel.uId.toString()).putFile(profilePic!);  
    
    // getting the download link of image uploaded in storage
    String? imageUrl= await result.ref.getDownloadURL();


    // saving name and imageurl in the empty fields of usermodel
    widget.userModel.name=name;
    widget.userModel.profileUrl =imageUrl;

   // updating data in firestore 
    await FirebaseFirestore.instance.collection("ChatAppUsers").doc(widget.userModel.uId).set(widget.userModel.toMap()).then((value){
    debugPrint("profile complete !");
    
    Navigator.popUntil(context, (route) => route.isFirst);   
    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomePage(firebaseUser: widget.firebaseUser, userModel: widget.userModel))));
    });
  }
  
}


