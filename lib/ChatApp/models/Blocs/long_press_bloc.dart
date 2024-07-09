import 'package:cubit_form/cubit_form.dart';

sealed class msgBlue{}
final class MsgSelect extends msgBlue{}



// Observing change in state using onChange and onTransition method 

class LongPressBloc extends Bloc<msgBlue,bool>{
  LongPressBloc(bool initial):super(initial){          // initializing statye with 0
 on<MsgSelect>((even,emit){
  emit(!state);
    });
  }
}