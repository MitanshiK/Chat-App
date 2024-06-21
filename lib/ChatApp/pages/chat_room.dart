import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:proj/ChatApp/models/chat_room_model.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/message_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/open_media.dart';
import 'package:proj/ChatApp/pages/send_media.dart';
import 'package:proj/main.dart';
import 'package:video_player/video_player.dart';

class ChatRoomPage extends StatefulWidget {
  final User firebaseUser; // <us> or current user on our side
  final UserModel userModel; // <us> our info

  final UserModel targetUser; // <other> person we are talking to
  final ChatRoomModel chatRoomModel;

  const ChatRoomPage(
      {super.key,
      required this.firebaseUser,
      required this.userModel,
      required this.targetUser,
      required this.chatRoomModel});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

  PlatformFile? pickedImage;
  String? messageType;
  String? time;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    void sendMessage() async {
      String msg = messageController.text.trim();
      messageController
          .clear(); // to clear textfield after we send the  message

      if (msg != "") {
        MessageModel newMessage = MessageModel(
            // creating message
            messageId: uuid.v1(),
            senderId: widget.userModel.uId,
            text: msg,
            seen: false,
            createdOn: DateTime.now(),
            type: "text");

        // creating a messages collection inside chatroom docs and saving messages in them
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomModel.chatRoomId)
            .collection("messages")
            .doc(newMessage.messageId)
            .set(newMessage.toMap())
            .then((value) {
          debugPrint("message sent");
        });

        // setting last message in chatroom and saving in firestore
        widget.chatRoomModel.lastMessage = msg;
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomModel.chatRoomId)
            .set(widget.chatRoomModel.toMap());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.targetUser.profileUrl.toString()),
              backgroundColor: const Color.fromARGB(255, 240, 217, 148),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(widget.targetUser.name.toString())
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 113, 210, 246),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            // to show messages
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(12),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomModel.chatRoomId)
                    .collection("messages")
                    .orderBy("createdOn",
                        descending:
                            true) // so that messages appear from newer to older
                    .snapshots(), // to convert into streams

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data
                          as QuerySnapshot; // converting into QuerySnapshot dataType

                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var dt = dataSnapshot.docs[index].data() as Map<
                              String,
                              dynamic>; // map of data at particular index
                          // var a=dt[index];
                          debugPrint("${dt.containsValue("hyy")}");
                          late final currentMessage;

                          ///

                          if (dt.containsValue("text") == true) {
                            // if message is text
                            currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            messageType = "text";
                          } else if (dt.containsValue("image") == true ||
                              dt.containsValue("video") == true) {
                            currentMessage = MediaModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            if (dt.containsValue("image") == true) {
                              messageType = "image";
                            } else if (dt.containsValue("video") == true) {
                              videoController =
                                  VideoPlayerController.networkUrl(
                                      Uri.parse(currentMessage.fileUrl));
                              _initializeVideoPlayerFuture =
                                  videoController!.initialize();
                              messageType = "video";
                            }
                          }

                          time =
                              "${currentMessage.createdOn!.hour}: ${currentMessage.createdOn!.minute}";

                          return Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                                // wraped in row so that width of message box is occourdung to content
                                mainAxisAlignment: (currentMessage.senderId ==
                                        widget.userModel.uId)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 10, 10),
                                    decoration: BoxDecoration(
                                        borderRadius: (currentMessage
                                                    .senderId ==
                                                widget.userModel.uId)
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20))
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                        color: (currentMessage.senderId ==
                                                widget.userModel.uId)
                                            ? const Color.fromARGB(
                                                255, 240, 217, 148)
                                            : const Color.fromARGB(
                                                255, 251, 162, 156)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          (messageType == "text")
                                              ? Text(currentMessage.text
                                                  .toString())
                                              :
                                              // subconition 1
                                              (messageType != "text")
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        // viewing image
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OpenMedia(
                                                                          mediamodel:
                                                                              currentMessage,
                                                                          userModel:
                                                                              widget.userModel,
                                                                          senderUid:
                                                                              currentMessage.senderId,
                                                                          date:
                                                                              currentMessage.createdOn, type: currentMessage.type,
                                                                        )));
                                                      },
                                                      child: (messageType =="image")
                                                          ? ConstrainedBox(
                                                              constraints:const BoxConstraints(
                                                                      maxHeight: 200,
                                                                      maxWidth:200),
                                                              child:Image.network(
                                                                currentMessage
                                                                    .fileUrl
                                                                    .toString(),
                                                              ),
                                                            )
                                                          : (messageType ==
                                                                  "video")
                                                              ? // image
                                                              FutureBuilder(
                                                                  future:
                                                                      _initializeVideoPlayerFuture,
                                                                  builder: (BuildContext context,AsyncSnapshot<dynamic>
                                                                          snapshot) {
                                                                    return Stack(
                                                                      children: [
                                                                        
                                                                        ConstrainedBox(
                                                                          constraints: const BoxConstraints(
                                                                              maxHeight: 200,
                                                                              maxWidth: 200),
                                                                          child:
                                                                              AspectRatio(
                                                                            aspectRatio:
                                                                                videoController!.value.aspectRatio,
                                                                            child:
                                                                                VideoPlayer(videoController!),
                                                                          ),
                                                                        ),
                                                                        const Positioned(
                                                                            bottom: 10,
                                                                            left: 10,
                                                                            child: Icon(
                                                                              Icons.play_arrow,
                                                                              color: Colors.white,
                                                                              size: 25,
                                                                            )),
                                                                      ],
                                                                    );
                                                                  },
                                                                )
                                                              : const Placeholder()) //video
                                                  : const Placeholder(), //text
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            time!,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          )
                                        ]),
                                  )
                                ]),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                          "Error Occured !! Please check our internet Connection");
                    } else {
                      return Text("Say Hi to ${widget.targetUser.name}");
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )),

            // for typing messages
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                color: const Color.fromARGB(255, 230, 229, 229),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          try {
                            await KeyboardEmojiPicker().checkHasEmojiKeyboard();
                            debugPrint("emojii");
                          } catch (e) {
                            debugPrint("the emoji error is $e");
                          }

                          // final hasEmojiKeyBoard= await KeyboardEmojiPicker().checkHasEmojiKeyboard();
                          // if(hasEmojiKeyBoard==true){
                          //  await KeyboardEmojiPicker().pickEmoji();
                          //  debugPrint("emojii");
                          // }
                          // else{
                          //   debugPrint("no emoji");
                          // }
                        },
                        icon: const Icon(Icons.emoji_emotions)),
                    PopupMenuButton(
                      icon: const Icon(Icons.attach_file),
                      itemBuilder: (BuildContext context) => [
                        // to share image
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            await selectImage(FileType.image);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMedia(
                                          mediaToSend: pickedImage!,
                                          chatRoom: widget.chatRoomModel,
                                          userModel: widget.userModel,
                                          type: "image",
                                        ))); // await bcs , it will wait for pic to be selected then navigate to next page
                          },
                          title: const Text("Image"),
                          leading: const Icon(Icons.image),
                        )),

                        // to share video
                        PopupMenuItem(
                            child: ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            await selectImage(FileType.video);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMedia(
                                          mediaToSend: pickedImage!,
                                          chatRoom: widget.chatRoomModel,
                                          userModel: widget.userModel,
                                          type: 'video',
                                        ))); // await bcs , it will wait for pic to be selected then navigate to next page
                          },
                          title: const Text("Video"),
                          leading: const Icon(Icons.video_camera_front),
                        )),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        maxLines: null,
                        controller: messageController,
                        decoration: const InputDecoration(hintText: "message"),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(Icons.send))
                  ],
                ))
          ],
        ),
      )),
    );
  }

  // selecting image from gallary to send
  Future selectImage(FileType mediaType) async {
    final result = await FilePicker.platform.pickFiles(type: mediaType);

    setState(() {
      pickedImage = result!.files.first;
    });
  }
}
