import 'package:cubit_form/cubit_form.dart';

sealed class Selection{}
final class Chatselection extends Selection{}



// Observing change in state using onChange and onTransition method 

class ChatSelectedBloc extends Bloc<Selection,bool>{
  ChatSelectedBloc(super.initial){          // initializing statye with 0
 on<Chatselection>((even,emit){
  emit(!state);
    });
  }
}