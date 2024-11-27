import 'package:cubit_form/cubit_form.dart';

sealed class MsgBlue{}
final class MsgSelect extends MsgBlue{}



// Observing change in state using onChange and onTransition method 

class LongPressBloc extends Bloc<MsgBlue,bool>{
  LongPressBloc(super.initial){          // initializing statye with 0
 on<MsgSelect>((even,emit){
  emit(!state);
    });
  }
}