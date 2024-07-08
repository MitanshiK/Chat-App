import 'package:cubit_form/cubit_form.dart';

sealed class ShowKeyBoard{}
final class emojiVisiblety extends ShowKeyBoard{}
final class emojiHide extends ShowKeyBoard{}


// Observing change in state using onChange and onTransition method 

class EmojiVisBloc extends Bloc<ShowKeyBoard,bool>{
  EmojiVisBloc(bool initial):super(initial){          // initializing statye with 0
 on<emojiVisiblety>((even,emit){
  emit(!state);
    });

  on<emojiHide>((even,emit){
  emit(false);
    });
  }
}