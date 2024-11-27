import 'dart:io';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioPlay extends StatefulWidget {
 AudioPlay({super.key ,required this.audioFile});
 PlatformFile? audioFile;

  @override
  State<AudioPlay> createState() => _AudioPlayState();
}

class _AudioPlayState extends State<AudioPlay> {
  File? file;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool picked=false;
  PlatformFile? pickedFile;
  String name="heyy";

 setAudio() async{
 await audioPlayer.setSourceDeviceFile(pickedFile!.path!);
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration=newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;
      });
    });
    pickedFile=widget.audioFile;
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name),
              ElevatedButton(onPressed: (){
                selectFile();
              }, child: const Text("pick File")),
              Slider(
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value)async {
                  // Add logic to update position
                  final position=Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();  // to play audio if it was paused
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(prettyDuration(duration)),
                  Text(prettyDuration(position)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        // var source = UrlSource("https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3");
                        await audioPlayer.resume();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                ],
              ),
            ],
          ),
      
      
    );
  }
  // picking Audio file from phone 
    Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio
    );
    setState(() {
      picked=true;
      pickedFile = result?.files.first;
      name=pickedFile!.name;
     
    });
    Isolate.run(setAudio());
    }
    // for time 
    String prettyDuration(Duration duration) {
  var seconds = (duration.inMilliseconds % (60 * 1000)) / 1000;
  return '${duration.inMinutes}:${seconds.toStringAsFixed(0)}';
}
}
