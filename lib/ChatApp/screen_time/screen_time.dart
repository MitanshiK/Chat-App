// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:proj/ChatApp/models/screen_time_model.dart';
// import 'package:proj/ChatApp/models/user_model.dart';

// /// [date.toString().replaceRange(5, 10, "")] removes the year at the end of date
// class Screentime extends StatefulWidget {
//   const Screentime(
//       {super.key, required this.userModel, required this.firebaseUser});
//   final UserModel userModel;
//   final User firebaseUser;
//   @override
//   State<Screentime> createState() => _ScreentimeState();
// }

// class _ScreentimeState extends State<Screentime> {
//   List<ScreenTimeModel> screenTimeList=[];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Chat App",
//             style: TextStyle(
//                 fontWeight: FontWeight.w600, fontFamily: "EuclidCircularB")),

//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: 
//         // Column(
//         //   children: [
//             FutureBuilder(
//               future: FirebaseFirestore.instance
//         .collection("ChatAppUsers")
//         .doc(widget.userModel.uId)
//           .collection("screenTime")
//           .orderBy("todayDate",descending: true)
//           .get(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
//             {  
//             //  if(snapshot.connectionState==ConnectionState.active){ 
              
//               if(snapshot.hasData){
//                 // debugPrint(" snapshot data is ${snapshot.data!.docs.first.data()}");
//                         screenTimeList.clear();
//                       for (var a in snapshot.data!.docs) {
//                         // ScreenTimeModel screenTimeModel = ScreenTimeModel(date: a.data().keys.first ,screenTime: a.data().values.first);
//                             ScreenTimeModel screenTimeModel = ScreenTimeModel.fromMap(a.data()  as Map<String,dynamic>);
//                            screenTimeModel.date=DateFormat("dd/MM/yyyy").format(screenTimeModel.todayDate!).toString().replaceRange(5, 10, "");
//                            screenTimeModel.screenTime= a.data()[DateFormat("dd/MM/yyyy").format(screenTimeModel.todayDate!).toString().replaceAll("/", "-")];
//                            //  ScreenTimeModel.fromMap(a.data());
//                           //   debugPrint(" value of a is ${a.data()}");
//                           // debugPrint("screentime model is ${screenTimeModel.date}");
//                         screenTimeList.add(screenTimeModel);
//                       }

//               //   QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

//               // getScreenTime(dataSnapshot);
              
//             return Container(
//                   decoration: const BoxDecoration(
//                     color:Colors.white,
//                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
//                   ),
//                   margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
//                   padding: const EdgeInsets.all(15),
//                   width: MediaQuery.sizeOf(context).width,
//                   height: MediaQuery.sizeOf(context).width/1.2,
//                   // maxHeight: MediaQuery.sizeOf(context).height
//                   child:
//                   BarChart(
//                               mainBarData()
//                             ),
//         );
//             //  SfCartesianChart(
//             //     primaryXAxis: const CategoryAxis(),
//             //   legend: const Legend(isVisible:  true),
//             //   tooltipBehavior: TooltipBehavior(enable: true),
//             //   title: const ChartTitle(text: "Screen Time"),
//             //   ///////
//             //   series: <LineSeries<ScreenTimeModel,String>>[
//             //       LineSeries<ScreenTimeModel,String>(
//             //         dataSource:screenTimeList,
//             //         xValueMapper: (ScreenTimeModel screenTime,_) => screenTime.date, // values along x axis
//             //         yValueMapper: (ScreenTimeModel screenTime,_) => (screenTime.screenTime!/60/60).round() , // values along y axis
//             //         // xAxisName: "Months",
//             //         // yAxisName: "victim",
                    
              
//             //          dataLabelSettings: const DataLabelSettings(isVisible: true), //shows the values on map
//             //         //  markerSettings: const MarkerSettings(isVisible: true),// shows dots on value on graph
//             //          ),
//             //      ]
//             //             /////
//             //   );
              
//                }else if(snapshot.hasError){
//                 return Center(child: Text("an error Occured ${snapshot.error}"));
//                }
//                else if(snapshot.hasData==false){
//                 return const Center(child: Text("No Screentime recorded"),);
//                }
//                 else{
//                 return const Center(child: Text("No screen Time"));
//                }
//               // } else{
//               //   return const Center(child:  Text("Connection Error"));
//               // }
//               }
//             )
//         //   ],
//         // )
//         ,),
//     );
//   }
  
//   void getScreenTime(QuerySnapshot<Object?> dataSnapshot) {
//     // ScreenTimeModel screenTimeModel;

//     for (var dt in dataSnapshot.docs) {
//      late final screenTimeModel =
//           ScreenTimeModel.fromMap(dt.data() as Map<String, dynamic>);
// debugPrint("screen time is ${screenTimeModel.todayDate}");
//           screenTimeList.add(screenTimeModel);
//     }
//   }

// //   Future  getScreenTime() async {
// //  var result;
// //   List<ScreenTimeModel> screenTimeListLocal=[];
// //    try{ 
// //      result =await FirebaseFirestore.instance
// //         .collection("ChatAppUsers")
// //         .doc(widget.userModel.uId)
// //           .collection("screenTime").snapshots().listen((event){
// //              ScreenTimeModel screenTimeModel;
// //              for(var aa in event.docs){
// //                screenTimeModel=  ScreenTimeModel.fromMap(aa.data()); // getting data of single day
// //               screenTimeListLocal.add(screenTimeModel);   // adding to list 
// //              }
// //              screenTimeList.addAll(screenTimeListLocal);
// //         //   screenTimeModel= ScreenTimeModel.fromMap(event.docs);
// //         debugPrint("screen time list 1 ${screenTimeList.toString()}");
// //           });
// //             debugPrint("screen time list 2 ${screenTimeList.toString()}");
// //     } catch (e) {
// //       debugPrint("unable to get screentime $e");
// //     }

// //     if (result != null) {}
// //   }

// BarChartGroupData makeGroupData(int x, double y) {
//       return BarChartGroupData(
//         x: x,
//         barRods: [
//           BarChartRodData(
//           toY: y,
//           width: 20,
//             gradient: const LinearGradient(colors: [
//               Color.fromARGB(255, 238, 228, 139),
//               Color.fromARGB(255, 244, 148, 141),
//               Color.fromARGB(255, 158, 217, 238)
//             ],
//             transform: GradientRotation(3.14/40)
//             ),
//           backDrawRodData: BackgroundBarChartRodData(
//             show: true,
//             color: Colors.grey.shade300,
//             toY: 5,
//           )
//           ),
//         ]
        
//         );
//     }

//     List<BarChartGroupData> showingGroups() => List.generate((screenTimeList.length <7) ? screenTimeList.length :7,(i) {
//      int index= (screenTimeList.length <7) ? screenTimeList.length-(i+1) :7-(i+1);
    
//     debugPrint("value of i is ${screenTimeList[index].screenTime!/3600}");
//      print("x axis value is ${DateFormat("dd/MM/yyyy").format(screenTimeList[index].todayDate!).toString().replaceRange(5, 10, "")}");
    
//     // screenTimeList[i].date=DateFormat("dd/MM/yyyy").format(screenTimeList[i].todayDate!).toString().replaceRange(5, 10, "");
//     // String key=DateFormat("dd/MM/yyyy").format(screenTimeList[i].todayDate!).toString().replaceAll("/","-");
//     return makeGroupData(i, screenTimeList[index].screenTime!/3600);
//     });

//   BarChartData mainBarData() {
//     return BarChartData(
//       titlesData:  FlTitlesData(
//       show: true,
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       leftTitles:   AxisTitles(
//         sideTitles: SideTitles(showTitles: true ,
//         reservedSize: 38,
//         getTitlesWidget: leftTileWidget
//         ),
//       ),
//       topTitles:  const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       bottomTitles:  AxisTitles(
//         sideTitles: SideTitles(showTitles: true,
//         reservedSize: 38,
//         getTitlesWidget: tilesWidget
//         ),
//       )
//       ),
//       borderData: FlBorderData(show: false),
//       gridData: const FlGridData(show: false),
//       barGroups: showingGroups()
//     );
//   }
  
//   Widget tilesWidget(double value ,TitleMeta meta) {
//    const style=TextStyle(
//     color: Colors.grey,
//     fontSize: 10,
//     fontFamily: "Euclid",
//     fontWeight: FontWeight.bold
//    );

//    Widget text = const Text("00",style: style);

// if(screenTimeList.length < 7){
//   double caseval=screenTimeList.length-1;
//   for(var i  in screenTimeList){

//    if(value == caseval){ 
//     text=Text(i.toString().replaceRange(5, 10, ""),style: style);
//     }
//     caseval-- ;
//   }
//   debugPrint("less that 7");

//   }else{
//    debugPrint("more than 7");
//    switch(value){
//     case 0:
//     text=  Text(  screenTimeList[6].date!,style: style);
//     break;

//     case 1:
//     text=  Text(   screenTimeList[5].date! ,style: style);
//     break;

//     case 2:
//     text=  Text(DateFormat("dd/MM/yyyy").format(screenTimeList[4].todayDate!).toString().replaceRange(5, 10, ""),style: style);
//     break;

//     case 3:
//     text=  Text(DateFormat("dd/MM/yyyy").format(screenTimeList[3].todayDate!).toString().replaceRange(5, 10, ""),style: style);
//     break;

//     case 4:
//     text=  Text(DateFormat("dd/MM/yyyy").format(screenTimeList[2].todayDate!).toString().replaceRange(5, 10, ""),style: style);
//     break;

//     case 5:
//     text=  Text(DateFormat("dd/MM/yyyy").format(screenTimeList[1].todayDate!).toString().replaceRange(5, 10, ""),style: style);
//     break;

//     case 6:
//     text=  Text(DateFormat("dd/MM/yyyy").format(screenTimeList[0].todayDate!).toString().replaceRange(5, 10, ""),style: style);
//     break;
    
//     default:
//     text=const Text("",style: style);
//     break;
//    }
//   }
  
//    return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 16,
//     child: text);
//   }

//   Widget leftTileWidget(double value ,TitleMeta meta){
//      const style=TextStyle(
//     color: Colors.grey,
//     fontSize: 14,
//     fontFamily: "Euclid",
//     fontWeight: FontWeight.bold
//    );
  
//   String text;
//   if(value==0){
//     text= "0hr";
//   }else if(value==1){
//     text= "1hr";
//   }else if(value==2){
//     text= "2hr";
//   }else if(value==3){
//     text= "3hr";
//   }else if(value==4){
//     text= "4hr";
//   }else if(value==5){
//     text= "5hr";
//   }else{
//     return Container();
//   }

//   return  SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 16,
//     child: Text(text, style: style));
//   }
  
// }
