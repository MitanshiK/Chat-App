import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/group_room_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/contacts/read_contacts.dart';
import 'package:proj/ChatApp/pages/for_media/send_media.dart';

class ShareBottomModal extends StatefulWidget {
  const ShareBottomModal({super.key , this.chatRoomModel ,required this.userModel ,this.groupRoomModel});
 final GroupRoomModel? groupRoomModel;
 final UserModel userModel;
 final ChatRoomModel?   chatRoomModel;

  @override
  State<ShareBottomModal> createState() => _ShareBottomModalState();
}

class _ShareBottomModalState extends State<ShareBottomModal> {
    PlatformFile? pickedMedia;
   String? capturedFile;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
        maxChildSize: 1,
        builder: (BuildContext context,
                ScrollController
                    scrollController) // scrollcontroller for dragging the menu up and down
            {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20))),
            child:  Column(
              children: <Widget>[
                // Row 1
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //1
                   GestureDetector(
                    onTap: () async{
                      // Navigator.pop(context);
                       await selectImage(FileType.image); 
                                            //  Navigator.pop(context);// await bcs , it will wait for pic to be selected then navigate to next page
               
                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "image",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "image",
                                                        )));
                                            }
                                                         
                                      },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 236, 113, 154),
                          child: Icon(Icons.image ,color: Colors.white,),
                         ),
                         Text("Image" ,style: TextStyle(fontFamily:"EuclidCircularB"))
                       ],
                     ),
                   ),

                   //2
                    GestureDetector(
                    onTap: ()async{
                      
                       await selectImage(FileType.video);
                      Navigator.pop(context);
                        
                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "video",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!.path!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "video",
                                                        )));
                                            }
                                                        
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.video_camera_back ,color: Colors.white,),
                         ),
                         Text("Video" ,style: TextStyle(fontFamily:"EuclidCircularB"))
                       ],
                     ),
                   ),
               //3
                GestureDetector(
                    onTap: ()async{
                                        //  Navigator.pop(context);
                                            await selectImage(FileType.audio);
                                             Navigator.pop(context); 

                                           if(widget.chatRoomModel!= null){
                                            Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!,
                                                          chatRoom: widget.chatRoomModel,
                                                          userModel: widget.userModel,
                                                          type: "audio",
                                                        )));
                                            }
                                            else if(widget.groupRoomModel!= null){
                                                Navigator.push( context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMedia(
                                                          mediaToSend:pickedMedia!,
                                                          userModel: widget.userModel,
                                                          groupRoomModel: widget.groupRoomModel!,
                                                          type: "audio",
                                                        )));
                                            }
                                            debugPrint(
                                                "${File(pickedMedia!.path!)} is audio path  ${pickedMedia!.path}");
                                    
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.audio_file ,color: Colors.white,),
                         ),
                         Text("Audio",style: TextStyle(fontFamily:"EuclidCircularB"))
                       ],
                     ),
                   ),

                
                    ],
                ),
               const SizedBox(height: 20,),
                 // Row 2
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  
                   
                   //1
                    GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      
                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.location_pin ,color: Colors.white,),
                         ),
                         Text("Location",style: TextStyle(fontFamily:"EuclidCircularB"))
                       ],
                     ),
                   ),

                   //2
                    GestureDetector(
                    onTap: (){
                      Navigator.pop(context);   
                      if(widget.chatRoomModel!=null){
                        
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                       ReadContacts(
                                                        chatRoomModel: widget.chatRoomModel!, userModel: widget.userModel,)));
                      }
                       else  if(widget.groupRoomModel!=null){
                         
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                       ReadContacts(
                                                        groupRoomModel: widget.groupRoomModel!, userModel: widget.userModel,)));
                      }

                    },
                     child: const Column(
                       children: [
                         CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.contacts,color: Colors.white,),
                         ),
                         Text("Contacts",style: TextStyle(fontFamily:"EuclidCircularB"))
                       ],
                     ),
                   ),
                      //3
                    const CircleAvatar(
                     radius: 30,
                     backgroundColor: Colors.transparent,
                     
                    ),
                   
                  ])
              ],
            ),
          );
        }
        );
  }
    // selecting image from gallary to send
  Future selectImage(FileType mediaType) async {
    final result = await FilePicker.platform.pickFiles(type: mediaType);

    setState(() {
      pickedMedia = result!.files.first;
    });
  }

  //////////////////////////////
   void chooseDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Camera",
                  style: TextStyle(fontFamily: "EuclidCircularB")),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // for picture
                  IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        await fromCamera("picture");

                        if (widget.chatRoomModel != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendMedia(
                                      mediaToSend: capturedFile!,
                                      chatRoom: widget.chatRoomModel,
                                      userModel: widget.userModel,
                                      type: "image")));
                        } else if (widget.groupRoomModel != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendMedia(
                                      mediaToSend: capturedFile!,
                                      groupRoomModel: widget.groupRoomModel,
                                      userModel: widget.userModel,
                                      type: "image")));
                        }
                      },
                      icon: const Icon(Icons.image)),

                  // for video
                  IconButton(
                    iconSize: 40,
                    onPressed: () async {
                      Navigator.pop(context);
                      await fromCamera("video");

                      if (widget.chatRoomModel != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMedia(
                                    mediaToSend: capturedFile!,
                                    chatRoom: widget.chatRoomModel,
                                    userModel: widget.userModel,
                                    type: "video")));
                      } else if (widget.groupRoomModel != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMedia(
                                    mediaToSend: capturedFile!,
                                    groupRoomModel: widget.groupRoomModel,
                                    userModel: widget.userModel,
                                    type: "video")));
                      }
                    },
                    icon: const Icon(Icons.video_camera_back),
                  )
                ],
              ));
        });
  }

  // video Or image from camera
  Future fromCamera(String cameraType) async {
   late final captured ;
    if(cameraType=="picture"){
     captured = await ImagePicker().pickImage(source: ImageSource.camera);
    }else if( cameraType=="video"){
       captured = await ImagePicker().pickVideo(source: ImageSource.camera);
    }

    if(captured != null) {
      setState(() {
         capturedFile=captured.path;
      }); 
    }
  }

}