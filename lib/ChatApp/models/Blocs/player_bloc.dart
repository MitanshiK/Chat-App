import 'package:cubit_form/cubit_form.dart';

sealed class ShowPlayer{}
final class PlayerVisibility extends ShowPlayer{}


// Observing change in state using onChange and onTransition method 

class PlayerVisBloc extends Bloc<ShowPlayer,bool>{
  PlayerVisBloc(bool initial):super(initial){          // initializing statye with 0
on<PlayerVisibility>((even,emit){
 emit(!state);
                   });
  }
}