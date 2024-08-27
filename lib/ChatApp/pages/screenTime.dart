import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/screen_time_model.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Screentime extends StatefulWidget {
  const Screentime(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;
  @override
  State<Screentime> createState() => _ScreentimeState();
}

class _ScreentimeState extends State<Screentime> {
  List<ScreenTimeModel> screenTimeList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chat App  ",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontFamily: "EuclidCircularB")),

      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: 
        // Column(
        //   children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
        .collection("ChatAppUsers")
        .doc(widget.userModel.uId)
          .collection("screenTime").get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
            {  
            //  if(snapshot.connectionState==ConnectionState.active){ 
              
              if(snapshot.hasData){
                print(" snapshot data is ${snapshot.data!.docs.first.data()}");

                      for (var a in snapshot.data!.docs) {
                        ScreenTimeModel screenTimeModel = ScreenTimeModel(date: a.data().keys.first ,screenTime: a.data().values.first);
                          //   ScreenTimeModel.fromMap(a.data());
                          //   print(" value of a is ${a.data()}");
                          print("screentime model is ${screenTimeModel.date}");
                        screenTimeList.add(screenTimeModel);
                      }

              //   QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

              // getScreenTime(dataSnapshot);
              
             return SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
              legend: const Legend(isVisible:  true),
              tooltipBehavior: TooltipBehavior(enable: true),
              title: const ChartTitle(text: "Screen Time"),
              ///////
              series: <LineSeries<ScreenTimeModel,String>>[
                  LineSeries<ScreenTimeModel,String>(
                    dataSource:screenTimeList,
                    xValueMapper: (ScreenTimeModel screenTime,_) => screenTime.date, // values along x axis
                    yValueMapper: (ScreenTimeModel screenTime,_) => (screenTime.screenTime!/60/60).round() , // values along y axis
                    // xAxisName: "Months",
                    // yAxisName: "victim",
                    
              
                     dataLabelSettings: const DataLabelSettings(isVisible: true), //shows the values on map
                    //  markerSettings: const MarkerSettings(isVisible: true),// shows dots on value on graph
                     ),
                 ]
                        /////
              );
               }else if(snapshot.hasError){
                return Center(child: Text("an error Occured ${snapshot.error}"));
               }
                else{
                return const Center(child: Text("No screen Time"));
               }
              // } else{
              //   return const Center(child:  Text("Connection Error"));
              // }
              }
            )
        //   ],
        // )
        ,),
    );
  }
  
  void getScreenTime(QuerySnapshot<Object?> dataSnapshot) {
    // ScreenTimeModel screenTimeModel;

    for (var dt in dataSnapshot.docs) {
     late final screenTimeModel =
          ScreenTimeModel.fromMap(dt.data() as Map<String, dynamic>);
print("screen time is ${screenTimeModel.date}");
          screenTimeList.add(screenTimeModel);
    }
  }

//   Future  getScreenTime() async {
//  var result;
//   List<ScreenTimeModel> screenTimeListLocal=[];
//    try{ 
//      result =await FirebaseFirestore.instance
//         .collection("ChatAppUsers")
//         .doc(widget.userModel.uId)
//           .collection("screenTime").snapshots().listen((event){
//              ScreenTimeModel screenTimeModel;
//              for(var aa in event.docs){
//                screenTimeModel=  ScreenTimeModel.fromMap(aa.data()); // getting data of single day
//               screenTimeListLocal.add(screenTimeModel);   // adding to list 
//              }
//              screenTimeList.addAll(screenTimeListLocal);
//         //   screenTimeModel= ScreenTimeModel.fromMap(event.docs);
//         print("screen time list 1 ${screenTimeList.toString()}");
//           });
//             print("screen time list 2 ${screenTimeList.toString()}");
//     } catch (e) {
//       print("unable to get screentime $e");
//     }

//     if (result != null) {}
//   }


}
