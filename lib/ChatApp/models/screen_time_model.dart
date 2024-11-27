
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ScreenTimeModel{
 String? date;
 int? screenTime;
DateTime? todayDate;

   ScreenTimeModel({
    this.date,
    this.screenTime
   ,this.todayDate 
   });

 factory ScreenTimeModel.fromMap(Map<String,dynamic> mapData){   
   return ScreenTimeModel( 
     date:  DateFormat("dd/MM/yyyy").format((mapData['todayDate'] as Timestamp).toDate()).toString().replaceRange(5, 10, "") ,
      // mapData['date'] ?? 'Unknown date',
      screenTime: mapData['screenTime'] ?? 0,
      todayDate: (mapData['todayDate'] as Timestamp?)?.toDate(),
      );

  }

Map<String,dynamic> toMap(){
  return {
    "date": date,
    "screenTime":screenTime,
    "todayDate":todayDate,
  };
 }
}