import 'package:cubit_form/cubit_form.dart';

sealed class ShowKeyBoard{}
final class EmojiVisiblety extends ShowKeyBoard{}
final class EmojiHide extends ShowKeyBoard{}


// Observing change in state using onChange and onTransition method 

class EmojiVisBloc extends Bloc<ShowKeyBoard,bool>{
  EmojiVisBloc(super.initial){          // initializing statye with 0
 on<EmojiVisiblety>((even,emit){
  emit(!state);
    });

  on<EmojiHide>((even,emit){
  emit(false);
    });
  }
}