class ChatRoomModel {
  String? chatRoomId;
  Map<String,dynamic>? participantsId; //id of 2 participants of the chatroom
  String? lastMessage;

  ChatRoomModel({this.chatRoomId, this.participantsId,this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> mapData) {
    chatRoomId = mapData["chatRoomId"];
    participantsId = mapData["participantsId"];
      lastMessage = mapData["lastMessage"];
  }

  Map<String, dynamic> toMap() {
    return {
    "chatRoomId": chatRoomId, 
    "participantsId": participantsId,
     "lastMessage": lastMessage
    };
    
  }
}
