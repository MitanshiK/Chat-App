
class ScreenTimeModel{
 String? date;
 int? screenTime;


   ScreenTimeModel({this.date,this.screenTime });

 factory ScreenTimeModel.fromMap(Map<String,dynamic> mapData){   
   return ScreenTimeModel( 
     date: mapData['date'] ?? 'Unknown date',
      screenTime: mapData['screenTime'] ?? 0,);

  }

Map<String,dynamic> toMap(){
  return {
    "date": date,
    "screenTime":screenTime,
  };
}
}