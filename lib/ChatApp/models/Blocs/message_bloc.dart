
import 'package:cubit_form/cubit_form.dart';

sealed class HideOrShow{}
final class HasText extends HideOrShow{}
final class NoText extends HideOrShow{}


// Observing change in state using onChange and onTransition method 

class MessageBloc extends Bloc<HideOrShow,bool>{
  MessageBloc():super(false){          // initializing statye with 0
on<HasText>((even,emit){
emit(true);
                   });

 on<NoText>((even,emit){
emit(false);
                   });
 }
}