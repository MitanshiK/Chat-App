import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubit_form/cubit_form.dart';

sealed class LikePost {}

final class LikeTrue extends LikePost {}
final class LikeFalse extends LikePost{}
final class VisHeart extends LikePost{}

final class LikeTrueAndUpd extends LikePost {
  final String? uId;
  final String? mediaId;
  final String likerUid;

  LikeTrueAndUpd(this.uId, this.mediaId, this.likerUid); //1st
}

class ShowStoryBloc extends Bloc<LikePost, bool> {
  ShowStoryBloc(bool initial) : super(initial) {

    on<LikeTrue>((event, emit) {  // only to update liked value to true 
      emit(true);
    });

    on<LikeTrueAndUpd>((event, emit) async {  // to update liked value to true and add loker to database
      //2nd
      DocumentReference mediaDoc = FirebaseFirestore.instance
          .collection("ChatAppUsers")
          .doc(event.uId)
          .collection("status")
          .doc(event.mediaId);

      //// Add the userId to the likedBy array
      await mediaDoc.update({
        'likedBy': FieldValue.arrayUnion([event.likerUid]),
      });

      emit(true);
    });

     on<LikeFalse>((event, emit) {  // only to update liked value to true 
      emit(false);
    });
    
    // on<VisHeart>((event, emit) {  
    //   emit(true);
    //   Future.delayed(Duration(milliseconds: 100),(){
    //   emit(false);
    //   });
    // });
    
  }
}
