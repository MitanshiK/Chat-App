import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:video_player/video_player.dart';
// opening shared media
class OpenMedia extends StatefulWidget {
  OpenMedia(
      {super.key,
      required this.mediamodel,
      required this.userModel,
      required this.senderUid,
      required this.type,
      required this.date});
     final mediamodel;

  final UserModel userModel;
  final String senderUid;
  final String type;
  final DateTime date;

  @override
  State<OpenMedia> createState() => _OpenMediaState();
}

class _OpenMediaState extends State<OpenMedia> {
 VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

  @override
  void initState() {
   if(widget.type=="video"){
      videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediamodel.fileUrl));
      _initializeVideoPlayerFuture = videoController!.initialize();
   }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text( 
              (widget.senderUid == widget.userModel.uId) ? "You" : "Friend" ),
          titleTextStyle: const TextStyle(color: Colors.white ,fontFamily:"EuclidCircularB"),
          subtitle: Text("${widget.date}"),
          subtitleTextStyle: const TextStyle(color: Colors.white,fontSize: 10 ,fontFamily:"EuclidCircularB"),
        ),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            
            itemBuilder: (BuildContext context) => [ 
            PopupMenuItem(child: ListTile(
                         onTap: () async {
                            Map<Permission, PermissionStatus> statuses = await [
                                Permission.storage, 
                                //add more permission to request here.
                            ].request();

                            if(statuses[Permission.storage]!.isGranted){ 
                                var dir = await DownloadsPathProvider.downloadsDirectory;
                                if(dir != null){
                                  String? savename;

                                  if(widget.mediamodel.type=="image"){         // if file is image then extension is jpeg
                                      savename = "${widget.mediamodel.mediaId}.jpeg";
                                   }
                                   if(widget.type=="video"){
                                    savename="${widget.mediamodel.mediaId}.mp4";
                                   }
                                     
                                      String savePath = "${dir.path}/$savename";
                                      print(savePath);
                                      //output:  /storage/emulated/0/Download/banner.png
                                      try {
                                          await Dio().download(
                                              widget.mediamodel.fileUrl, 
                                              savePath,
                                              onReceiveProgress: (received, total) {
                                                  if (total != -1) {
                                                      print((received / total * 100).toStringAsFixed(0) + "%");
                                                      //you can build progressbar feature too
                                                  }
                                                });
                                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloaded" ,style: TextStyle(fontFamily:"EuclidCircularB")))) ; 
                                     } catch (e) {
                                       print(e);
                                     }
                                }
                            }else{
                               print("No permission to read and write.");
                            }

                         },
                         title: const Text("Download" ,style: TextStyle(fontFamily:"EuclidCircularB")),
                      ))
            ],
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints:
                 BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height-50,
              maxWidth: MediaQuery.sizeOf(context).width-50),
              child:
              (widget.type=="image")? Image.network(widget.mediamodel.fileUrl ,cacheWidth: 700,):
               (widget.type=="video")?   
               FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return Center(
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: videoController!.value.aspectRatio,
                                  child: VideoPlayer(videoController!),
                                ),
                                Positioned(
                                  top: MediaQuery.sizeOf(context).height / 3,
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (videoController!
                                                .value.isPlaying) {
                                              videoController!.pause();
                                            } else {
                                              videoController!.play();
                                            }
                                          },
                                          icon: Icon(
                                            videoController!.value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_circle,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ) :Placeholder()
                      ///
              
              ),
            )
            ],
        ),
      ),
    );
  }



}
