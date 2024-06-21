// import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/services.dart';

// // class AudioRecord extends StatefulWidget {
// //   const AudioRecord({super.key});

// //   @override
// //   State<AudioRecord> createState() => _AudioRecordState();
// // }

// // class _AudioRecordState extends State<AudioRecord>  with TickerProviderStateMixin {
// // late AnimationController _animationIconController1;
// // late AudioCache audioCache;
// // late AudioPlayer audioPlayer;
// // Duration _duration =  Duration();
// // Duration _position =  Duration();
// // Duration _slider =  Duration(seconds: 0);
// // late double durationvalue;
// // bool issongplaying = false;

// //  @override
// //   void initState() {
// // _position = _slider;
// //     _animationIconController1 = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 750),
// //       reverseDuration: Duration(milliseconds: 750),
// //     );
// //     audioPlayer =  AudioPlayer();
// //     audioCache =  AudioCache();

// //     audioPlayer.
// //     // audioPlayer.durationHandler = (d) => setState(() {
// //     //       _duration = d;
// //     //     });

// //     audioPlayer.positionHandler = (p) => setState(() {
// //           _position = p;
// //         });
// //     super.initState();
// //  }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Record Audio"),
// //       ),
// //     );
// //   }
// // }

// class AudioRec extends  StatefulWidget {
//   @override
//   State<AudioRec> createState() => _AudioRecState();
// }

// class _AudioRecState extends State<AudioRec> {

//   int maxduration = 100;
//   int currentpos = 0;
//   String currentpostlabel = "00:00";
//   String audioasset = "assets/spirited_away.mp3";
//   bool isplaying = false;
//   bool audioplayed = false;
//   late Uint8List audiobytes;

//   AudioPlayer player = AudioPlayer();

//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () async {

//        ByteData bytesSong = await rootBundle.load(audioasset); //load audio from assets
//        audiobytes = bytesSong.buffer.asUint8List(bytesSong.offsetInBytes, bytesSong.lengthInBytes);
//        //convert ByteData to Uint8List

//        player.onDurationChanged.listen((Duration d) { //get the duration of audio
//            maxduration = d.inMilliseconds; 
//            setState(() {
             
//            });
//        });

//       player.onDurationChanged.listen((Duration  p){
//         currentpos = p.inMilliseconds; //get the current position of playing audio

//           //generating the duration label
//           int shours = Duration(milliseconds:currentpos).inHours;
//           int sminutes = Duration(milliseconds:currentpos).inMinutes;
//           int sseconds = Duration(milliseconds:currentpos).inSeconds;

//           int rhours = shours;
//           int rminutes = sminutes - (shours * 60);
//           int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

//           currentpostlabel = "$rhours:$rminutes:$rseconds";

//           setState(() {
//              //refresh the UI
//           });
//       });

//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//          appBar: AppBar(
//             title: Text("Play Audio in Flutter App"),
//             backgroundColor: Colors.redAccent
//          ),
//          body: Container( 
//                margin: EdgeInsets.only(top:50),
//                child: Column(
//                  children: [

//                       Container(
//                          child: Text(currentpostlabel, style: TextStyle(fontSize: 25),),
//                       ),
                      
//                       Container(
//                         child: Slider(
//                             value: double.parse(currentpos.toString()),
//                             min: 0,
//                             max: double.parse(maxduration.toString()),
//                             divisions: maxduration,
//                             label: currentpostlabel,
//                             onChanged: (double value) async {
//                                int seekval = value.round();
//                              await   player.seek(Duration(milliseconds: seekval)); //
//                                if(player.seek(Duration(milliseconds: seekval)) == 1){ //seek successful
//                                     currentpos = seekval;
//                                }else{
//                                     print("Seek unsuccessful.");
//                                }
//                             },
//                           )
//                       ),

//                       Container(
//                         child: Wrap( 
//                             spacing: 10,
//                             children: [
//                                 ElevatedButton.icon(
//                                   onPressed: () async {
//                                       if(!isplaying && !audioplayed){
//                                            await player.play(audiobytes as Source);
//                                           // .playBytes(audiobytes);
//                                           if(player.play(audiobytes as Source) == 1){ //play success
//                                               setState(() {
//                                                  isplaying = true;
//                                                  audioplayed = true;
//                                               });
//                                           }else{
//                                               print("Error while playing audio."); 
//                                           }
//                                       }else if(audioplayed && !isplaying){
//                                           await player.resume();
//                                           if(player.resume() == 1){ //resume success
//                                               setState(() {
//                                                  isplaying = true;
//                                                  audioplayed = true;
//                                               });
//                                           }else{
//                                               print("Error on resume audio."); 
//                                           }
//                                       }else{
//                                           await player.pause();
//                                           if( player.pause() == 1){ //pause success
//                                               setState(() {
//                                                  isplaying = false;
//                                               });
//                                           }else{
//                                               print("Error on pause audio."); 
//                                           }
//                                       }
//                                   }, 
//                                   icon: Icon(isplaying?Icons.pause:Icons.play_arrow),
//                                   label:Text(isplaying?"Pause":"Play")
//                                 ),

//                                 ElevatedButton.icon(
//                                   onPressed: () async {
//                                      await player.stop();
//                                       if(player.stop() == 1){ //stop success
//                                           setState(() {
//                                               isplaying = false;
//                                               audioplayed = false;
//                                               currentpos = 0;
//                                           });
//                                       }else{
//                                           print("Error on stop audio."); 
//                                       }
//                                   }, 
//                                   icon: Icon(Icons.stop),
//                                   label:Text("Stop")
//                                 ),
//                             ],
//                         ),
//                       )

//                  ],
//                )
          
//           )
//     );
//   } 
// }

