
class UserModel{
  String? uId;
  String? name;
  String? email;
  String? profileUrl;

  UserModel({this.uId,this.name,this.email,this.profileUrl});

  UserModel.fromMap(Map<String,dynamic> mapData){   // same as fromjson fun in api integration

    uId=mapData["uId"];
    name=mapData["name"];
    email=mapData["email"];
    profileUrl=mapData["profileUrl"];

  }

Map<String,dynamic> toMap(){
  return {
    "uId": uId,
    "name":name,
    "email":email,
    "profileUrl":profileUrl,
  };
}
}