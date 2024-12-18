import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj/ChatApp/models/media_model.dart';
import 'package:proj/ChatApp/models/screen_time_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/story/archive_story.dart';
import 'package:video_player/video_player.dart';

/// [date.toString().replaceRange(5, 10, "")] removes the year at the end of date
class Screentime extends StatefulWidget {
  const Screentime(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;
  @override
  State<Screentime> createState() => _ScreentimeState();
}

class _ScreentimeState extends State<Screentime> {
  List<ScreenTimeModel> screenTimeList = [];
  List<MediaModel> allStories = [];
  String messageType = "";
  VideoPlayerController? videoController; // video controller for videoPlayer
  late Future<void> _initializeVideoPlayerFuture; // future for video

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chat App",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontFamily: "EuclidCircularB")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("ChatAppUsers")
                      .doc(widget.userModel.uId)
                      .collection("screenTime")
                      .orderBy("todayDate", descending: true)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      screenTimeList.clear();
                      for (var a in snapshot.data!.docs) {
                        ScreenTimeModel screenTimeModel =
                            ScreenTimeModel.fromMap(a.data());
                        screenTimeModel.date = DateFormat("dd/MM/yyyy")
                            .format(screenTimeModel.todayDate!)
                            .toString()
                            .replaceRange(5, 10, "");
                        screenTimeModel.screenTime = a.data()[
                            DateFormat("dd/MM/yyyy")
                                .format(screenTimeModel.todayDate!)
                                .toString()
                                .replaceAll("/", "-")];
        
                        screenTimeList.add(screenTimeModel);
                      }
        
                      return Column(
                        children: [
                          const Text(
                "Screen Time",
                style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "EuclidCircularB",
                    fontSize: 25),
              ),
              const SizedBox(
                height: 15,
              ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).width / 1.2,
                            child: BarChart(mainBarData()),
                          ),
                        ],
                      );
                      //  SfCartesianChart(
                      //     primaryXAxis: const CategoryAxis(),
                      //   legend: const Legend(isVisible:  true),
                      //   tooltipBehavior: TooltipBehavior(enable: true),
                      //   title: const ChartTitle(text: "Screen Time"),
                      //   ///////
                      //   series: <LineSeries<ScreenTimeModel,String>>[
                      //       LineSeries<ScreenTimeModel,String>(
                      //         dataSource:screenTimeList,
                      //         xValueMapper: (ScreenTimeModel screenTime,_) => screenTime.date, // values along x axis
                      //         yValueMapper: (ScreenTimeModel screenTime,_) => (screenTime.screenTime!/60/60).round() , // values along y axis
                      //         // xAxisName: "Months",
                      //         // yAxisName: "victim",
                      //          dataLabelSettings: const DataLabelSettings(isVisible: true), //shows the values on map
                      //         //  markerSettings: const MarkerSettings(isVisible: true),// shows dots on value on graph
                      //          ),
                      //      ]
                      //  ///////
                      //   );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("an error Occured ${snapshot.error}"));
                    } else if (snapshot.hasData == false) {
                      return const Center(
                        child: Text("No Screentime recorded"),
                      );
                    } else {
                      return const Center(child: Text("No screen Time"));
                    }
                  }),
                  const SizedBox(height: 15,),
              ExpansionTile(
                title: const Text("Archieved Stories",style: TextStyle(color: Colors.grey,fontFamily:"EuclidCircularB" ),),
                initiallyExpanded: false,
                children: [
                     StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChatAppUsers")
                    .doc(widget.userModel.uId)
                    .collection("status")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                      allStories.clear();
                      for (var i in dataSnapshot.docs) {
                        late final currentStory =
                            MediaModel.fromMap(// data into model
                                i.data() as Map<String, dynamic>);
        
                        allStories.add(currentStory);
                      }
                      return SizedBox(
                        height: 400,
                        width: MediaQuery.sizeOf(context).width,
                        child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 160,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.1
                                  ),
                            children: List.generate(allStories.length, (int index) {
                              if (allStories[index].type == "image") {
                                messageType = "image";
                              } else if (allStories[index].type == "video") {
                                videoController = VideoPlayerController.network(
                                    Uri.parse(allStories[index].fileUrl!).toString());
                                _initializeVideoPlayerFuture =
                                    videoController!.initialize();
                                messageType = "video";
                              }
                              return Container(
                                // height: MediaQuery.sizeOf(context).width/3,
                                // width: MediaQuery.sizeOf(context).width/3,
                                padding: const EdgeInsets.all(3),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            // viewing image
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ArchiveStory(
                                                          mediamodel:
                                                              allStories[index],
                                                          senderUid:
                                                              allStories[index]
                                                                  .senderId!,
                                                          date: allStories[index]
                                                              .createdOn!,
                                                          type: allStories[index]
                                                              .type!,
                                                          userModel:
                                                              widget.userModel,
                                                        )));
                                          },
                                          child: (messageType == "image")
                                              ? Stack(
                                                children: [
                                                    SizedBox(
                                                      // constraints: BoxConstraints(
                                                      height: MediaQuery.sizeOf(context).width /3,
                                                      width: MediaQuery.sizeOf(context).width,
                                                      // ),
                                                      child: Image.network(
                                                        allStories[index]
                                                            .fileUrl
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      left: 10,
                                                      child: Text(DateFormat("dd/MM/yyyy").format(allStories[index].createdOn!),
                                                                  style:  const TextStyle(color: Colors.white ,
                                                                                          fontFamily:"EuclidCircularB",
                                                                                          fontSize: 10),))
                                                  ],
                                                 )
                                              : (messageType == "video")
                                                  ? // image
                                                  Stack(
                                                    children: [
                                                        FutureBuilder(
                                                          future:
                                                              _initializeVideoPlayerFuture,
                                                          builder:
                                                              (BuildContext context,AsyncSnapshot<dynamic> snapshot) {
                                                            return Stack(
                                                              children: [
                                                                SizedBox(
                                                                  // constraints: BoxConstraints(
                                                                  height:
                                                                      MediaQuery.sizeOf(context).width /3,
                                                                  width:
                                                                      MediaQuery.sizeOf(context).width,
                                                                  // ),
                                                                  child:
                                                                      //  AspectRatio(
                                                                      //   aspectRatio: videoController!
                                                                      //       .value.aspectRatio,
                                                                      //   child:
                                                                      VideoPlayer(videoController!),
                                                                  // ),
                                                                ),
                                                                const Positioned(
                                                                    bottom: 10,
                                                                    left: 10,
                                                                    child: Icon(
                                                                      Icons.play_arrow,
                                                                      color:
                                                                          Colors.white,
                                                                      size: 25,
                                                                    )),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                         Positioned(
                                                      top: 5,
                                                      left: 10,
                                                      child: Text(DateFormat("dd/MM/yyyy").format(allStories[index].createdOn!),
                                                                  style:  const TextStyle(color: Colors.white ,
                                                                                          fontFamily:"EuclidCircularB",
                                                                                          fontSize: 10),))
                                                      ],
                                                  )
                                                  : Container()),
                                      //text
                                      const SizedBox( height: 5,),
                                    ]),
                              );
                            })),
                      );
                    }
                  }else{
                    return const Text("No Stories");
                  }
                  return const Text("No Stories");
                },
              )
            
                ],),
             
            ],
          ),
        ),
      ),
    );
  }

  void getScreenTime(QuerySnapshot<Object?> dataSnapshot) {
    for (var dt in dataSnapshot.docs) {
      late final screenTimeModel =
          ScreenTimeModel.fromMap(dt.data() as Map<String, dynamic>);
      debugPrint("screen time is ${screenTimeModel.todayDate}");
      screenTimeList.add(screenTimeModel);
    }
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: y,
          width: 20,
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 238, 228, 139),
            Color.fromARGB(255, 244, 148, 141),
            Color.fromARGB(255, 158, 217, 238)
          ], transform: GradientRotation(3.14 / 40)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            color: Colors.grey.shade300,
            toY: 5,
          )),
    ]);
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate((screenTimeList.length < 7) ? screenTimeList.length : 7,
          (i) {
        int index = (screenTimeList.length < 7)
            ? screenTimeList.length - (i + 1)
            : 7 - (i + 1);

        // debugPrint("value of i is ${screenTimeList[index].screenTime! / 3600}");
        debugPrint(
            "x axis value is ${DateFormat("dd/MM/yyyy").format(screenTimeList[index].todayDate!).toString().replaceRange(5, 10, "")}");

        return makeGroupData(i,screenTimeList[index].screenTime! / 3600);
      });

  BarChartData mainBarData() {
    return BarChartData(
        titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  getTitlesWidget: leftTileWidget),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  getTitlesWidget: tilesWidget),
            )),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: showingGroups());
     }

  Widget tilesWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.grey,
        fontSize: 10,
        fontFamily: "Euclid",
        fontWeight: FontWeight.bold);

    Widget text = const Text("00", style: style);

    if (screenTimeList.length < 7) {
      double caseval = screenTimeList.length - 1;
      for (var i in screenTimeList) {
        if (value == caseval) {
          text = Text(i.date!, style: style);
        }
        caseval--;
      }
      debugPrint("less that 7");
    } else {
      debugPrint("more than 7");
      switch (value) {
        case 0:
          text = Text(screenTimeList[6].date!, style: style);
          break;

        case 1:
          text = Text(screenTimeList[5].date!, style: style);
          break;

        case 2:
          text = Text(
              screenTimeList[4].date!,
              style: style);
          break;

        case 3:
          text = Text(
              screenTimeList[3].date!,
              style: style);
          break;

        case 4:
          text = Text(
              screenTimeList[2].date!,
              style: style);
          break;

        case 5:
          text = Text(
             screenTimeList[1].date!,
              style: style);
          break;

        case 6:
          text = Text(
              screenTimeList[0].date!,
              style: style);
          break;

        default:
          text = const Text("", style: style);
          break;
      }
    }

    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: text);
  }

  Widget leftTileWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontFamily: "Euclid",
        fontWeight: FontWeight.bold);

    String text;
    if (value == 0) {
      text = "0hr";
    } else if (value == 1) {
      text = "1hr";
    } else if (value == 2) {
      text = "2hr";
    } else if (value == 3) {
      text = "3hr";
    } else if (value == 4) {
      text = "4hr";
    } else if (value == 5) {
      text = "5hr";
    } else {
      return Container();
    }

    return SideTitleWidget(
        axisSide: meta.axisSide, space: 16, child: Text(text, style: style));
  }
}
