import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/helpers/firebase_helper.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/story/show_story.dart';
import 'package:proj/ChatApp/pages/story/story_file_upload.dart';

class Stories extends StatefulWidget {
  const Stories({super.key, required this.firebaseUser, required this.userModel});
  final User firebaseUser;
  final UserModel userModel;

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  PlatformFile? pickedMedia;
  bool hasStory = false;

  List<String> friendsStories=[]; // for stories
@override
  void initState() {
   usersWithStories();
   hasStoryFun(widget.userModel.uId!);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // user
            ListTile(
              onTap: () {
                chooseDialog();
              },
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                     if(hasStory == true){ 
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowStory(
                                  firebaseUser: widget.firebaseUser,
                                  userModel: widget.userModel)
                            ));
                            }
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: hasStory
                            ? const Color.fromARGB(255, 22, 227, 207)
                            : Colors.transparent,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(widget.userModel.profileUrl!),
                        )),
                  ),
                  // const Visibility(
                  //   visible:  true,
                  //   child:
                     const Positioned(
                      bottom: -5,
                      right: -5,
                      child: Icon(
                        Icons.add_circle,
                        color: Color.fromARGB(255, 240, 217, 148),
                      ),
                    ),
                  // ),
                ],
              ),
              title: const Text("My Status" ,style: TextStyle(fontFamily:"EuclidCircularB"),),
              subtitle: const Text("Tap to add status update" ,style: TextStyle(fontFamily:"EuclidCircularB")),
            ),
            const Divider(),
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Recent Updates",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold ,fontFamily:"EuclidCircularB"),
                )),
            // friends
          
          ///////////////////////////////////////////////////////////////
          
          ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height / 2),
                      child:
                      ListView.builder(
            itemCount: friendsStories.length,
            itemBuilder: (BuildContext context, int index) { 
               return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                friendsStories[index]), // passing target user id
                               
                            builder: (context, snapshot) {
                              
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  UserModel userData =snapshot.data as UserModel;

                                  return Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowStory(
                                                          firebaseUser: widget.firebaseUser,
                                                          userModel:userData)
                                                        )
                                                      );
                                        },
                                        title: Text(userData.name.toString(),style: const TextStyle(fontFamily:"EuclidCircularB")),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: const Color.fromARGB(
                                              255, 22, 227, 207),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 158, 219, 241),
                                            backgroundImage: NetworkImage(
                                                userData.profileUrl.toString()),
                                          ),
                                        )),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );

             },)
          )

            ////////////////
          ],
        ),
     
    );
  }

  // selecting image from gallary to send
  Future<void> selectImage(FileType mediaType) async {
    final result = await FilePicker.platform.pickFiles(type: mediaType);
    setState(() {
      pickedMedia = result?.files.first;
    });
  }

   void chooseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose media type" ,style: TextStyle(fontFamily:"EuclidCircularB")),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                 
              // for picture
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                          // Navigator.pop(context);
                  
                      await selectImage(FileType.image);
                      if (pickedMedia != null) {
                        if(mounted){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryFileUpload(
                              status: pickedMedia!.path,
                              type: 'image',
                              userModel: widget.userModel,
                            ),
                          ),
                        );
                        }
                       
                      }
                    },
                    icon: const Icon(Icons.image ,size: 40,),
                  ),
                 const Text("Image" ,style:  TextStyle(fontFamily:"EuclidCircularB"),)
                ],
              ),

              // for video
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                          // Navigator.pop(context); 
                          
                      await selectImage(FileType.video);
                      // Navigator.pop(context);
                      if (pickedMedia != null) {
                        if(mounted){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryFileUpload(
                                status: pickedMedia!.path,
                                type: 'video', userModel: widget.userModel,
                              ),
                            ));
                        }
                        // Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.video_camera_back ,size: 40,),
                  ),
                 const Text("Video" ,style: TextStyle(fontFamily:"EuclidCircularB"),)

                ],
              ),
            ],
          ),
        );
      },
    );
  
  }

  void usersWithStories(){
    List<String> otherUsers=[]; // users
   List< List<MediaModel> > recentStoryList=[]; // stories

     FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participantsId.${widget.userModel.uId}",
                      isEqualTo: true)
                  .snapshots().listen((event) {
                 for(var i in event.docs){ 

                     ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              i.data());

                          // to get targetUser Id
                          Map<String, dynamic> participants = chatRoomModel
                              .participantsId!; // getting participants
                          List<String> participantsList = participants.keys
                              .toList(); // getting participants keys and saving in list
                          participantsList.remove(widget.userModel
                              .uId); // removing currentUser key so that we are left with targetuser id
                          /////
                  otherUsers.add(participantsList[0]);
                  } // 1st for 
                  debugPrint (otherUsers.toString());
              
            List<MediaModel> singleUserStory=[];
              for(var j in otherUsers){

                      FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .doc(j)
                    .collection("status")
                    .orderBy("createdOn", descending: true)
                    .snapshots().listen((event) {

          singleUserStory.clear();  // imp

                        for (var i in event.docs) {
      late final currentStory = MediaModel.fromMap(// data into model
          i.data() as Map<String, dynamic>);

      DateTime a = currentStory.createdOn!;
      DateTime b = DateTime.now();
      var diff = b.difference(a).inHours; // to know if its been 24 hours or not
          
      if (diff <= 24) {
          singleUserStory.add(currentStory);
      }  
      // debugPrint("singlestory of $j is ${currentStory.fileUrl}");
      // debugPrint("difference between current time ${DateTime.now().hour} and story${currentStory.createdOn!.hour} is ${diff} ");
    }
    recentStoryList.add(singleUserStory);
    if(singleUserStory.isNotEmpty){
      setState(() {
        if(friendsStories.contains(j)==false){
        friendsStories.add(j);
        }
      });
    }
        // debugPrint("friens with stories are 1 ${friendsStories}");
   debugPrint("singlestory of $j is ${singleUserStory.length}");
      // debugPrint("list of all stories is ${recentStoryList[0].length} for $j  second ${recentStoryList[1].length} ");

                    }); // second stream  
                  }
                  });


  }

  void hasStoryFun(String userId){
      List<MediaModel> singleUserStory=[];
                      FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .doc(userId)
                    .collection("status")
                    .orderBy("createdOn", descending: true)
                    .snapshots().listen((event) {
                        for (var i in event.docs) {
      late final currentStory = MediaModel.fromMap(// data into model
          i.data() as Map<String, dynamic>);

      DateTime a = currentStory.createdOn!;
      DateTime b = DateTime.now();
      var diff = b.difference(a).inHours; // to know if its been 24 hours or not

      if (diff <= 24) {
          singleUserStory.add(currentStory);
      }
   debugPrint(" current user stories count is ${singleUserStory.length}");
      // debugPrint("difference between current time ${DateTime.now().hour} and story${currentStory.createdOn!.hour} is ${diff} ");
    }
     debugPrint(" current user stories count 2 is ${singleUserStory.length}");
 if(singleUserStory.isNotEmpty){
  setState(() {
    hasStory=true;
  });
  debugPrint("value of hasStory is $hasStory");
 }

  });
  }
}
